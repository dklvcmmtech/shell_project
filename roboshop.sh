#!/bin/bash

AMI_ID=ami-0220d79f3f480ecf5
SG_ID=sg-00baaac08a16be1ba
SUBNET_ID=subnet-00ba107509e7b0969
INSTANCES=("mongodb" "redis" "mysql" "rabbitmq" "catalogue" "shipping" "dispatch" "user" "cart" "payment" "frontend")
INSTANCES_TEMP=("mongodb")

ZONE_ID="Z099736537TMITZQUCER4"
DOMAIN_NAME="learn-devops.site"

for instance in ${INSTANCES_TEMP[@]}
do
    INSTANCE_ID=$(aws ec2 run-instances --image-id $AMI_ID --instance-type t3.micro --security-group-ids $SG_ID --tag-specifications "ResourceType=instance,Tags=[{Key=Name, Value=$instance}]" --query "Instances[0].InstanceId" --output text)

    if [ $instance != 'frontend']
    then
        IP = $(aws ec2 describe-instances --instance-ids $INSTANCE_ID --query "Reservations[0].Instances[0].PrivateIpAddress" --output text)
    else
        IP = $(aws ec2 describe-instances --instance-ids $INSTANCE_ID --query "Reservations[0].Instances[0].PublicIpAddress" --output text)
    fi
    echo "$instance IP is $IP:"

done
