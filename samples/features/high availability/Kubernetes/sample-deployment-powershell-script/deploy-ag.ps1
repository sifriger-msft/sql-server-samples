Param(
    [parameter(Mandatory=$false)]
    [string]$NamespaceName="ag1"
)

$currentWorkingDirectory = (Get-Location).Path | Split-Path -Parent
$manifestRootDirectory = Join-Path $currentWorkingDirectory "k8s/AKS"

Set-Location $manifestRootDirectory

Write-Host "Creating namespace"  -ForegroundColor Yellow
kubectl create namespace $NamespaceName
Write-Host "Namespace $NamespaceName created successfully" -ForegroundColor Cyan

Write-Host "Deploying SQL Server Operator" -ForegroundColor Yellow

kubectl apply `
--filename operator.yml `
--namespace $NamespaceName

Write-Host "SQL Server Operator deployed successfully" -ForegroundColor Cyan

Write-Host "Creating SA password and master key password" -ForegroundColor Yellow

kubectl create `
secret generic sql-secrets `
--from-literal=sapassword="P@ssw0rd!" `
--from-literal=masterkeypassword="P@ssw0rd!"  `
--namespace $NamespaceName

Write-Host "Created SA password and master key password successfully" -ForegroundColor Yellow

Write-Host "Deploying SQL Server custom resource" -ForegroundColor Yellow

kubectl apply `
--filename sqlserver.yml `
--namespace $NamespaceName

Write-Host "SQL Server custom resource deployed successfully" -ForegroundColor Cyan

Write-Host "Deploying SQL Server Availability Group" -ForegroundColor Yellow

kubectl apply `
--filename agservices.yml `
--namespace $NamespaceName

Write-Host "SQL Server Availability Group deployed successfully" -ForegroundColor Cyan