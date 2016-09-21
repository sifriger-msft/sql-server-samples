FROM microsoft/windowsservercore

SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop';"]

#SQL Server Express 2016 (64 bit) 13.0.1601.5
ENV DOWNLOAD_URL https://download.microsoft.com/download/E/1/2/E12B3655-D817-49BA-B934-CEB9DAC0BAF3/SQLEXPR_x64_ENU.exe

ENV SA_PASSWORD _

RUN (New-Object System.Net.WebClient).DownloadFile($env:DOWNLOAD_URL, 'Setup.exe') ; \
	Start-Process -FilePath '\Setup.exe' \
	-ArgumentList '/Q', \
	'/ACTION=Install', \
	'/FEATURES=SQLEngine', \
	'/INSTANCENAME=MSSQLServer', \
	'/TCPENABLED=1', \
	'/NPENABLED=0', \
	'/UPDATEENABLED=0', \
	'/SQLSVCACCOUNT="""NT AUTHORITY\System"""', \
	'/SQLSYSADMINACCOUNTS="""BUILTIN\ADMINISTRATORS"""', \
	'/IAcceptSQLServerLicenseTerms', \
	'/SAPWD=Password1', \
	'/SECURITYMODE=SQL' \
	-Wait ; \
	Stop-Service mssqlserver ; \
	set-itemproperty -path 'HKLM:\software\microsoft\microsoft sql server\mssql13.MSSQLServer\mssqlserver\supersocketnetlib\tcp\ipall' -name tcpdynamicports -value '' ; \
	set-itemproperty -path 'HKLM:\software\microsoft\microsoft sql server\mssql13.MSSQLServer\mssqlserver\supersocketnetlib\tcp\ipall' -name tcpport -value 1433 ; \
	set-itemproperty -path 'HKLM:\software\microsoft\microsoft sql server\mssql13.MSSQLServer\mssqlserver\\' -name LoginMode -value 2 ; \
	Remove-Item Setup.exe

RUN [Environment]::SetEnvironmentVariable('PATH', $env:ProgramFiles + '\Microsoft SQL Server\130\Tools\Binn;' + $env:PATH, [EnvironmentVariableTarget]::Machine);

CMD Start-Service mssqlserver ; \
	if ($env:SA_PASSWORD -ne '_') { \
		Write-Host Changing SA login credentials...; \
		$sqlcmd = 'ALTER LOGIN sa with password=''' + $env:SA_PASSWORD + ''';'; \
		Invoke-Sqlcmd -Query $sqlcmd -ServerInstance 'localhost,1433' \
	} ; \
	Write-Host SQL Server started... ; \
	while ($true) { Start-Sleep -Seconds 3600 }

EXPOSE 1433
