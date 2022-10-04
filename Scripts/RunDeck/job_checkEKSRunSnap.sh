#!/bin/bash -x
export AWS_ACCESS_KEY_ID=$RD_OPTION_AWS_ACCESS_KEY_ID
export AWS_SECRET_ACCESS_KEY=$RD_OPTION_AWS_SECRET_ACCESS_KEY
echo @option.account@
echo @file.instancias@

## clear aws
rm -rf ~/.aws
mkdir -p ~/.aws

## Por padrão, a variavel @option.account@ recebe input da conta aws desejada,
## Mas caso seja necessário executar em varias contas, basta descomentar as linhas do array arn.
arn=(
    '@option.account@'
#    '1234567891128' #Lista de contas aws
    )

region=(us-east-1 us-east-2 us-west-1 us-west-2 sa-east-1)

for regiao in ${region[@]}; do
for conta in ${arn[@]}; do
  export AWS_ACCESS_KEY_ID=$RD_OPTION_AWS_ACCESS_KEY_ID
  export AWS_SECRET_ACCESS_KEY=$RD_OPTION_AWS_SECRET_ACCESS_KEY
  aws sts assume-role --role-arn "arn:aws:iam::$conta:role/NOME_ROLE_Rundeck" --role-session-name AWSCLI-Session --output json > sts.json
    RoleAccessKeyID=$(cat sts.json | jq ".Credentials.AccessKeyId" | sed 's/"//g')
    RoleSecretKey=$(cat sts.json | jq ".Credentials.SecretAccessKey" | sed 's/"//g')
    RoleSessionToken=$(cat sts.json | jq ".Credentials.SessionToken" | sed 's/"//g')

    cat >> ~/.aws/credentials <<EOF
[profile_aws]
aws_access_key_id = $RoleAccessKeyID
aws_secret_access_key = $RoleSecretKey
aws_session_token = $RoleSessionToken
EOF

if [ @file.instancias@ ]; then
instancias=$(cat @file.instancias@)
else
instancias=$(aws ec2 describe-instances --query 'Reservations[*].Instances[*].{Instancia:InstanceId}' --profile profile_aws --region $regiao --output text)
fi

for ec2 in ${instancias[@]}; do
grepeks=$(aws ec2 describe-instances --instance $ec2 --profile profile_aws --region $regiao | grep -q -e 'eks' -q -e 'kubernetes' -q -e 'node')
scaling=$(aws autoscaling describe-auto-scaling-instances --instance $ec2 --query 'AutoScalingInstances[*].{Instancia:InstanceId}' --profile profile_aws --region $regiao --output text)
    if [ -z "${grepeks}" ] && [ -z "${scaling}" ]; then
    if [ -z "$grepeks" ]; then
    aws ec2 create-tags \
      --resources $ec2 \
      --tags Key=Instalar,Value=EDR   Key=Description_task,Value=MarkedToInstallAV \
      --profile profile_aws \
      --region $regiao

     if aws ec2 describe-tags --filters "Name=resource-id,Values=$ec2" --profile profile_aws --region $regiao | grep -q 'MarkedToInstallAV'; then
       aws ec2 create-snapshots \
         --instance-specification InstanceId=$ec2 \
         --description "Criado por Rundeck-InstallEDR - ( $ec2 )" \
         --tag-specifications 'ResourceType=snapshot,Tags=[{Key=Name,Value=Instalacao AV},{Key=Description,Value="copia pre instalacao do EDR XYZ"}]' \
         --profile profile_aws \
         --region $regiao
fi    
fi
done
done
done
