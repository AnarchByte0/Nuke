# Create-Cert.ps1
$Subject = "CN=AnarchByte"
$CertStoreLocation = "Cert:\CurrentUser\My"
# Code Signing EID: 1.3.6.1.5.5.7.3.3
$TextExtension = "2.5.29.37={text}1.3.6.1.5.5.7.3.3"

Write-Host "Creating self-signed certificate for $Subject..." -ForegroundColor Cyan

$Cert = New-SelfSignedCertificate -Type Custom -Subject $Subject -KeyUsage DigitalSignature -FriendlyName "Nuke Dev Cert" -CertStoreLocation $CertStoreLocation -TextExtension $TextExtension

$Password = ConvertTo-SecureString -String "1234" -Force -AsPlainText
Export-PfxCertificate -Cert $Cert -FilePath "NukeDev.pfx" -Password $Password

Write-Host "Certificate created and exported to NukeDev.pfx with password '1234'" -ForegroundColor Green
Write-Host "NOTE: To install this MSIX, you must first double-click NukeDev.pfx and install it to 'Trusted Root Certification Authorities' on your machine." -ForegroundColor Yellow
