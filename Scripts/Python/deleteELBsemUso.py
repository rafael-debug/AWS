import boto3 
from datetime import datetime
import re


my_client=boto3.client('elbv2', region_name='us-east-1', use_ssl='true')
response = my_client.describe_load_balancers()

TERMINATION_AGE = 15

#date_string = re.search("User initiated \(([\d-]*)", reason).group(1)


for loadbalancer in (response["LoadBalancers"]):
    my_targetgroups=my_client.describe_target_groups(LoadBalancerArn=loadbalancer["LoadBalancerArn"])
    for my_targetgroup in my_targetgroups["TargetGroups"]:
        response_target=my_client.describe_target_health(TargetGroupArn=my_targetgroup["TargetGroupArn"])
        
        date = (loadbalancer['CreatedTime'])


        if (datetime.today().day) - date.day >= TERMINATION_AGE:
            if response_target["TargetHealthDescriptions"]==[]:
                print (loadbalancer["LoadBalancerName"])
                nameelb = (loadbalancer["LoadBalancerName"])
                my_client.delete_load_balancer(LoadBalancerArn=loadbalancer["LoadBalancerArn"])
                print(f"loadbalancer {nameelb} excluido com sucesso")