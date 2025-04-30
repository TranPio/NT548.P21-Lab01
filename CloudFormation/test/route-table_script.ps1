$Region = "ap-southeast-1"

$VpcId = aws cloudformation describe-stacks --stack-name network-stack `
    --query "Stacks[0].Outputs[?ExportName=='Network-VpcId'].OutputValue" --output text

$PublicSubnetId = aws cloudformation describe-stacks --stack-name network-stack `
    --query "Stacks[0].Outputs[?ExportName=='Network-PublicSubnetId'].OutputValue" --output text

$PrivateSubnetId = aws cloudformation describe-stacks --stack-name network-stack `
    --query "Stacks[0].Outputs[?ExportName=='Network-PrivateSubnetId'].OutputValue" --output text

$IGWId = aws cloudformation describe-stacks --stack-name network-stack `
    --query "Stacks[0].Outputs[?ExportName=='Network-IgwId'].OutputValue" --output text

$NatGatewayId = aws cloudformation describe-stacks --stack-name nat-stack `
    --query "Stacks[0].Outputs[?ExportName=='Network-NatGatewayId'].OutputValue" --output text

# ===== Deploy Route Tables =====
Write-Host "`n Deploying Route Tables..."
aws cloudformation deploy `
    --stack-name route-stack `
    --template-file "C:\Users\LOQ_BKND\Desktop\Lab1\NT548.P21-Lab01\CloudFormation\modules\route-tables.yaml" `
    --parameter-overrides `
    VpcId=$VpcId `
    IGWId=$IGWId `
    PublicSubnetId=$PublicSubnetId `
    PrivateSubnetId=$PrivateSubnetId `
    NatGatewayId=$NatGatewayId `
    ProjectName=nt548-lab01-group10-CloudFormation `
    --capabilities CAPABILITY_NAMED_IAM `
    --region $Region

Write-Host " Route Tables deployed."

# # ===== Test Route Table bằng dummy route =====
# Write-Host "`n Testing Route Table with dummy RT..."
# aws cloudformation deploy `
#     --stack-name test-route `
#     --template-file route-table-test-import.yaml `
#     --capabilities CAPABILITY_NAMED_IAM `
#     --region $Region

# Write-Host " Route Table test completed."

