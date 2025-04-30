$Region = "ap-southeast-1"
$KeyName = "my-keypair" 

# Deploying VPC Stack...
aws cloudformation deploy `
    --stack-name network-stack `
    --template-file "C:\Users\LOQ_BKND\Desktop\Lab1\NT548.P21-Lab01\CloudFormation\modules\vpc.yaml" `
    --parameter-overrides `
    VpcCidr=10.0.0.0/16 `
    PublicSubnetCidr=10.0.1.0/24 `
    PrivateSubnetCidr=10.0.2.0/24 `
    AvailabilityZone=$($Region + "a") `
    ProjectName=nt548-lab01-group10-CloudFormation `
    --capabilities CAPABILITY_NAMED_IAM `
    --region $Region

# ===== Lấy giá trị Outputs từ VPC Stack =====
Write-Host "`n Getting exported resource IDs..."
$VpcId = aws cloudformation describe-stacks --stack-name network-stack `
    --query "Stacks[0].Outputs[?ExportName=='Network-VpcId'].OutputValue" --output text

$PublicSubnetId = aws cloudformation describe-stacks --stack-name network-stack `
    --query "Stacks[0].Outputs[?ExportName=='Network-PublicSubnetId'].OutputValue" --output text

$PrivateSubnetId = aws cloudformation describe-stacks --stack-name network-stack `
    --query "Stacks[0].Outputs[?ExportName=='Network-PrivateSubnetId'].OutputValue" --output text

$IGWId = aws cloudformation describe-stacks --stack-name network-stack `
    --query "Stacks[0].Outputs[?ExportName=='Network-IgwId'].OutputValue" --output text

$SGId = aws cloudformation describe-stacks --stack-name network-stack `
    --query "Stacks[0].Outputs[?ExportName=='Network-DefaultSgId'].OutputValue" --output text

Write-Host "`n VPC ID: $VpcId"
Write-Host " IGW ID: $IGWId"
Write-Host " SG ID: $SGId"
Write-Host " Public Subnet: $PublicSubnetId"
Write-Host " Private Subnet: $PrivateSubnetId"

# # ===== Deploy test EC2 vào Public Subnet =====
# Write-Host "`n Deploying test EC2 in Public Subnet..."
# aws cloudformation deploy `
#     --stack-name test-vpc `
#     --template-file vpc-test.yaml `
#     --parameter-overrides KeyName=$KeyName `
#     --capabilities CAPABILITY_NAMED_IAM `
#     --region $Region

Write-Host " Test-VPC deployed."


# aws cloudformation delete-stack --stack-name network-stack --region "$Region"

# aws cloudformation delete-stack --stack-name test-vpc --region "$Region"