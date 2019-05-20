Param(
    [parameter(Mandatory=$false)]
    [string]$NamespaceName="ag1"
)

Write-Host "Creating namespace"  -ForegroundColor Yellow
kubectl apply --filename 00_AKS_Namespace.yml
Write-Host "Namespace $NamespaceName created successfully" -ForegroundColor Cyan

Write-Host "Deploying SQL Server Operator" -ForegroundColor Yellow

kubectl apply `
--filename 00_operator.yml `
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
--filename 04_sqlserver.yml `
--namespace $NamespaceName

Write-Host "SQL Server custom resource deployed successfully" -ForegroundColor Cyan

Write-Host "Deploying SQL Server Availability Group" -ForegroundColor Yellow

kubectl apply `
--filename 05-agservices.yml `
--namespace $NamespaceName

Write-Host "SQL Server Availability Group deployed successfully" -ForegroundColor Cyan