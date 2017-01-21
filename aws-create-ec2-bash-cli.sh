#!/bin/bash
# Description : Create AWS EC2 instances using the bash cli 
# Author : Patrick Hynes
# Date : 21.01.17

#Create instance
echo "Creating AWS EC2 Instanc based on json file"
instanceId=$(aws ec2 run-instances --cli-input-json file://input-file/ec2-run-instances.json --output text --query "Instances[].InstanceId")
echo "Instance ID:"  $instanceId

# Create an EIP and filter out the allocation id
allocationId=$(aws ec2 allocate-address --output text --query "AllocationId")
echo "Creating AWS EIP for the EC2 Instance...."
echo "Allocation ID:" $allocationId

#Wait until the instance is running before assing EIP or tags
echo "Waiting for instance to be running...."
aws ec2 wait instance-running --instance-ids $instanceId

#Associate EIP - to release address eg: aws ec2 release-address --public-ip 198.51.100.0
echo "Associating " $instanceId " with EIP allocationId " $allocationId
aws ec2 associate-address --instance-id $instanceId --allocation-id $allocationId

#Time to tag the instance
echo "Tagging :" $instanceId
aws ec2 create-tags --resources $instanceId --tags Key=Name,Value='EC2-Instance' Key=Environment,Value='Production'

read -p "EC2 Instance creation complete"