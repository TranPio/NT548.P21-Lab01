$Region = "ap-southeast-1"
# Truy vấn subnet có tag Type=public
$PublicSubnetId = aws ec2 describe-subnets `
    --filters "Name=tag:Type,Values=public" `
    --query "Subnets[0].SubnetId" `
    --output text `
    --region $Region

# ===== Deploy NAT Gateway =====
Write-Host "`n Deploying NAT Gateway..."
aws cloudformation deploy `
    --stack-name nat-stack `
    --template-file "C:\Users\LOQ_BKND\Desktop\Lab1\NT548.P21-Lab01\CloudFormation\modules\nat-gateway.yaml" `
    --parameter-overrides `
    PublicSubnetId=$PublicSubnetId `
    ProjectName=nt548-lab01-group10-CloudFormation `
    --capabilities CAPABILITY_NAMED_IAM `
    --region $Region

$NatGatewayId = aws cloudformation describe-stacks --stack-name nat-stack `
    --query "Stacks[0].Outputs[?ExportName=='Network-NatGatewayId'].OutputValue" --output text

Write-Host "NAT Gateway deployed: $NatGatewayId"

# # ===== Test NAT Gateway với EC2 trong Private Subnet =====
# Write-Host "`n Testing NAT Gateway..."
# aws cloudformation deploy `
#     --stack-name test-nat `
#     --template-file nat-gateway-test-import.yaml `
#     --parameter-overrides KeyName=$KeyName `
#     --capabilities CAPABILITY_NAMED_IAM `
#     --region $Region

# Write-Host "`n Hoàn tất toàn bộ quá trình deploy và test!"
