param (
    [string]$ProjectName = "nt548-lab01-group10-vpc_CloudFormation",
    [string]$VpcId = "vpc-05b95fc9ee9d23cee",
    [string]$AllowCidr = "118.71.93.213/32"
)

$stackName = "security-groups-stack"

Write-Host "`n========== Deploying Security Groups =========="

aws cloudformation deploy `
    --template-file "..\..\modules\security-group\security-group.yaml" `
    --stack-name $stackName `
    --parameter-overrides `
        ProjectName=$ProjectName `
        VPCId=$VpcId `
        AllowCidr=$AllowCidr `
    --capabilities CAPABILITY_NAMED_IAM

$publicSgId = (aws cloudformation describe-stacks --stack-name $stackName | ConvertFrom-Json).Stacks[0].Outputs |
    Where-Object { $_.OutputKey -eq "PublicSecurityGroupId" } |
    Select-Object -ExpandProperty OutputValue

$privateSgId = (aws cloudformation describe-stacks --stack-name $stackName | ConvertFrom-Json).Stacks[0].Outputs |
    Where-Object { $_.OutputKey -eq "PrivateSecurityGroupId" } |
    Select-Object -ExpandProperty OutputValue

Write-Host "Public SG:  $publicSgId"
Write-Host "Private SG: $privateSgId"
