# Web Server Exemplo
Esta pasta contém um exemplo de configuração do Terraform que implanta um cluster de servidores web (usando EC2 e Auto Scaling) e um balanceador de carga (usando ELB) para estudo pessoal. 

## Quick start
```
export AWS_ACCESS_KEY_ID=(your access key id)
export AWS_SECRET_ACCESS_KEY=(your secret access key)
```

Deploy do código:

```
terraform init
terraform plan -out=data.out
terraform apply data.out
```

Depois:
```
curl http://<alb_dns_name>/
```

*Rodar um terraform destroy no final para limpeza
