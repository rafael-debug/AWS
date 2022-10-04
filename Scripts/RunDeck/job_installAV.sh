#!/bin/bash -x
export AWS_ACCESS_KEY_ID=$RD_OPTION_AWS_ACCESS_KEY_ID
export AWS_SECRET_ACCESS_KEY=$RD_OPTION_AWS_SECRET_ACCESS_KEY
#export AWS_SESSION_TOKEN=$RD_OPTION_AWS_ACCESS_KEY_TOKEN

#clear aws
rm -rf ~/.aws
mkdir -p ~/.aws

## Por padrão, a variavel @option.account@ recebe input da conta aws desejada,
## Mas caso seja necessário executar em varias contas, basta descomentar as linhas do array arn. 
arn=(
    '@option.account@'
#    '123456781128' #lista de conta aws
    )

region=(us-east-1 us-east-2 us-west-1 us-west-2 sa-east-1)

for regiao in ${region[@]}; do
for conta in ${arn[@]}; do 
  export AWS_ACCESS_KEY_ID=$RD_OPTION_AWS_ACCESS_KEY_ID
  export AWS_SECRET_ACCESS_KEY=$RD_OPTION_AWS_SECRET_ACCESS_KEY
  aws sts assume-role --role-arn "arn:aws:iam::$conta:role/ROLE_AWS_Rundeck" --role-session-name AWSCLI-Session --output json > sts.json
    RoleAccessKeyID=$(cat sts.json | jq ".Credentials.AccessKeyId" | sed 's/"//g')
    RoleSecretKey=$(cat sts.json | jq ".Credentials.SecretAccessKey" | sed 's/"//g')
    RoleSessionToken=$(cat sts.json | jq ".Credentials.SessionToken" | sed 's/"//g')

    cat >> ~/.aws/credentials <<EOF
[profile_aws]
aws_access_key_id = $RoleAccessKeyID
aws_secret_access_key = $RoleSecretKey
aws_session_token = $RoleSessionToken
EOF

instances=$(aws ec2 describe-instances --query 'Reservations[].Instances[].{Instancia:InstanceId}' --profile profile_aws --region $regiao --output text)
for ec2 in ${instances[@]}; do
  ssmedr=$(aws ssm describe-instance-information --filters "Key=InstanceIds,Values=$ec2" --query "InstanceInformationList[*].{Instancia:InstanceId}" --profile profile_aws --region $regiao --output text)  
  tagedr=$(aws ec2 describe-tags --filters "Name=resource-id,Values=$ssmedr" --profile profile_aws --region $regiao | grep -i 'MarkedToInstallAV')
  if [ -n "${tagedr}" ]; then
  install=$ssmedr

aws ssm send-command \
    --document-name "AWS-RunRemoteScript" \
    --targets "Key=InstanceIds,Values=$install" \
    --parameters '{"sourceType":["S3"],"sourceInfo":["{\"path\":\"https://backt_S3.sh\"}"],"commandLine":["scriptedr.sh"]}' \
    --region $regiao \
    --profile profile_aws \
    --comment "Instalacao EDR AV via Rundeck na instancia $install" \
    --cloud-watch-output-config "CloudWatchOutputEnabled=true,CloudWatchLogGroupName=CWLGroupName"

  else
    echo "Instancia $ec2 sem EDR"
fi
done
done
done
echo > ~/.aws/credentials