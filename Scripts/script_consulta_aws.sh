# Este script faz consulta de instancias ec2 a partir de uma lista (em forma de variavel)
# A consulta me mostrará informações de ID de instancia e imagem, vpc, subnet, etc se existir em minha variavel. A saida é em forma de table, mas pode ser em json.
# VAR='(i130234|vpc1923954f|i-re934)'

aws ec2 describe-instances --query 'Reservations[].Instances[].{Instancia:InstanceId,Image:ImageId,Vpc:VpcId,subnet:SubnetId,Tipo:InstanceType,conta:IpOwnerId}' --output table | egrep $VAR
