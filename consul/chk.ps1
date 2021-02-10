add-type @"
using System.Net;
using System.Security.Cryptography.X509Certificates;
public class TrustAllCertsPolicy : ICertificatePolicy {
    public bool CheckValidationResult(
        ServicePoint srvPoint, X509Certificate certificate,
        WebRequest request, int certificateProblem) {
        return true;
    }
}
"@
$AllProtocolsIzenda = [System.Net.SecurityProtocolType]'Ssl3,Tls,Tls11,Tls12'
[System.Net.ServicePointManager]::SecurityProtocol = $AllProtocolsIzenda
[System.Net.ServicePointManager]::CertificatePolicy = New-Object TrustAllCertsPolicy
Invoke-WebRequest -OutFile nodejs.zip -UseBasicParsing "nodejs.org/dist/v12.4.0/node-v12.4.0-win-x64.zip"; 
Expand-Archive nodejs.zip -DestinationPath C:\; Rename-Item "C:\\node-v12.4.0-win-x64" c:\nodejs

$oldpath = (Get-ItemProperty -Path 'Registry::HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\Session Manager\Environment' -Name PATH).Path; `
$newpath = 'C:\nodejs;'+$oldpath; `
Set-ItemProperty -Path 'Registry::HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\Session Manager\Environment' -Name PATH -Value $newpath;

Invoke-WebRequest -OutFile mingit.zip -UseBasicParsing "https://github.com/git-for-windows/git/releases/download/v2.30.1.windows.1/MinGit-2.30.1-busybox-64-bit.zip"; 
Expand-Archive mingit.zip -DestinationPath c:\mingit ; 
Remove-Item mingit.zip -Force ; 

$oldpath1 = (Get-ItemProperty -Path 'Registry::HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\Session Manager\Environment' -Name PATH).Path; `
$newpath1 = 'c:\mingit\cmd;'+$oldpath1; `
Set-ItemProperty -Path 'Registry::HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\Session Manager\Environment' -Name PATH -Value $newpath1;
