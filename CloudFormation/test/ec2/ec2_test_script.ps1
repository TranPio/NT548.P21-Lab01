param (
    [string]$ProjectName = "nt548-lab01-group10_CloudFormation",
    [string]$VpcId = "vpc-05b95fc9ee9d23cee",
    [string]$PublicSubnetId = "subnet-0c01f6969ae3b0c0b",
    [string]$PrivateSubnetId = "subnet-0aee36b537b3813c0",
    [string]$AmiId = "ami-0c1907b6d738188e5",
    [string]$InstanceType = "t2.micro",
    [string]$PublicSecurityGroupId = "sg-0fa0b308fe294dcb1",
    [string]$PrivateSecurityGroupId = "sg-0c37d3cb4d78a2aff",
    [string]$ExistingKeyName = "nt548-lab01-group10_CloudFormation-key"
)

$stackName = "ec2-stack"

Write-Host "`n========== Deploying EC2 Instances =========="

aws cloudformation deploy `
    --template-file "..\..\modules\ec2\ec2.yaml" `
    --stack-name $stackName `
    --parameter-overrides `
        ProjectName=$ProjectName `
        VpcId=$VpcId `
        PublicSubnetId=$PublicSubnetId `
        PrivateSubnetId=$PrivateSubnetId `
        AmiId=$AmiId `
        InstanceType=$InstanceType `
        PublicSecurityGroupId=$PublicSecurityGroupId `
        PrivateSecurityGroupId=$PrivateSecurityGroupId `
        ExistingKeyName=$ExistingKeyName `
    --capabilities CAPABILITY_NAMED_IAM

# Retrieve Public EC2 ID
$publicEc2Id = (aws cloudformation describe-stacks --stack-name $stackName | ConvertFrom-Json).Stacks[0].Outputs |
    Where-Object { $_.OutputKey -eq "PublicEC2Id" } |
    Select-Object -ExpandProperty OutputValue

# Retrieve Private EC2 ID
$privateEc2Id = (aws cloudformation describe-stacks --stack-name $stackName | ConvertFrom-Json).Stacks[0].Outputs |
    Where-Object { $_.OutputKey -eq "PrivateEC2Id" } |
    Select-Object -ExpandProperty OutputValue

# Retrieve Key Pair Name
$keyPairName = (aws cloudformation describe-stacks --stack-name $stackName | ConvertFrom-Json).Stacks[0].Outputs |
    Where-Object { $_.OutputKey -eq "KeyName" } |
    Select-Object -ExpandProperty OutputValue

Write-Host "Public EC2 ID:  $publicEc2Id"
Write-Host "Private EC2 ID: $privateEc2Id"
Write-Host "Key Pair Name: $keyPairName"
