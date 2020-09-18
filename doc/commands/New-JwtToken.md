# New-JwtToken
Type: Function

Module: [Bca.Jwt](../ReadMe.md)

Creates a JWT token.
## Description
Creates a JWT token.
## Syntax
### FromSecret (default)
```powershell
New-JwtToken -Algorithm <string> -Secret <Object> [-Type <string>] [-Issuer <string>] [-Subject <string>] [-Audience <string>] [-Expiration <int>] [-Claims <Object>] [-KeyId <string>] [<CommonParameters>]
```
### FromCertificate
```powershell
New-JwtToken -Algorithm <string> -Certificate <X509Certificate2> [-Type <string>] [-Issuer <string>] [-Subject <string>] [-Audience <string>] [-Expiration <int>] [-Claims <Object>] [-KeyId <string>] [<CommonParameters>]
```
## Examples
### Example 1
```powershell
New-JwtToken -Algorithm HS256 -Issuer $TokenIssuer -Audience $TokenAudience -Secret $MySecret
```
This example will return a string containing the token.
### Example 2
```powershell
$Cert = Get-ChildItem Cert:\LocalMachine\my\CERTIFICATETHUMBPRINT
$PrivateKey = [System.Security.Cryptography.X509Certificates.RSACertificateExtensions]::GetRSAPrivateKey($Cert)
New-JwtToken -Algorithm RS256 -Claims @{ iss = $TokenIssuer ; aud = $TokenAudience } -Expiration 3600 -Secret $PrivateKey

```
This example will return a string containing the token.
### Example 3
```powershell
New-JwtToken -Algorithm RS256 -Claims '{"aud":"audience","iss":"issuer","sub":"subject"}' -Certificate (Get-ChildItem Cert:\LocalMachine\my\CERTIFICATETHUMBPRINT)
```
This example will return a string containing the token.
## Parameters
### `-Algorithm`
A string containing the algorithm to use.

| | |
|:-|:-|
|Type:|String|
|Aliases|alg|
|Parameter sets:|FromCertificate, FromSecret|
|Position:|Named|
|Required:|True|
|Accepts pipepline input:|False|
|Validation (ValidValues):|HS256, HS384, HS512, RS256, RS384, RS512|

### `-Type`
A string containing the token type.

| | |
|:-|:-|
|Type:|String|
|Aliases|typ|
|Default value:|JWT|
|Parameter sets:|FromCertificate, FromSecret|
|Position:|Named|
|Required:|False|
|Accepts pipepline input:|False|

### `-Issuer`
A string containing the issuer to use.

| | |
|:-|:-|
|Type:|String|
|Aliases|iss|
|Parameter sets:|FromCertificate, FromSecret|
|Position:|Named|
|Required:|False|
|Accepts pipepline input:|False|

### `-Subject`
A string containing the subject to use.

| | |
|:-|:-|
|Type:|String|
|Aliases|sub|
|Parameter sets:|FromCertificate, FromSecret|
|Position:|Named|
|Required:|False|
|Accepts pipepline input:|False|

### `-Audience`
A string containing the audience to use.

| | |
|:-|:-|
|Type:|String|
|Aliases|aud|
|Parameter sets:|FromCertificate, FromSecret|
|Position:|Named|
|Required:|False|
|Accepts pipepline input:|False|

### `-Expiration`
An integer representing either the number of seconds for which the token will be valid, or the value of the UNIX epoch time when the token will not be valid anymore.

| | |
|:-|:-|
|Type:|Int32|
|Aliases|exp, val, Validity, ValidFor|
|Default value:|3600|
|Parameter sets:|FromCertificate, FromSecret|
|Position:|Named|
|Required:|False|
|Accepts pipepline input:|False|

### `-Claims`
An object, hastable or JSON string representing the claims to add or set to the header (based on reserved header claims) or payload.
If a claim was already set using a parameter, it will be overriden.
If algorithm (alg) is specified throught a claim, it will be ignored. Algorithm must be set by Algorithm parameter.

| | |
|:-|:-|
|Type:|Object|
|Aliases|c|
|Parameter sets:|FromCertificate, FromSecret|
|Position:|Named|
|Required:|False|
|Accepts pipepline input:|False|

### `-Secret`
A string, secure string or certificate private key (for RSA) used to sign the token.

| | |
|:-|:-|
|Type:|Object|
|Aliases|sec, key, pk|
|Parameter sets:|FromSecret|
|Position:|Named|
|Required:|True|
|Accepts pipepline input:|False|
|Validation (ScriptBlock):|` if (($Algorithm -like "RS*") -and ($_.GetType().FullName -notin "System.Security.Cryptography.AsymmetricAlgorithm", "System.Security.Cryptography.RSACng")) { throw $script:LocalizedData.NewJwtToken.Error.NotPrivateKey } else { $true } `|

### `-KeyId`
A string containing the key ID.

| | |
|:-|:-|
|Type:|String|
|Aliases|kid|
|Parameter sets:|FromCertificate, FromSecret|
|Position:|Named|
|Required:|False|
|Accepts pipepline input:|False|

### `-Certificate`
An x509 certificate object used to sign the token if RSA algorithm is specified. The certificate object must contain the private key.
Using a certificate implicitely adds the claim 'x5t' (Base64 encoded thumbprint of the certificate) to the header.

| | |
|:-|:-|
|Type:|X509Certificate2|
|Aliases|cert|
|Parameter sets:|FromCertificate|
|Position:|Named|
|Required:|True|
|Accepts pipepline input:|False|
|Validation (ScriptBlock):|` if ($Algorithm -like "RS*") { if (!([System.Security.Cryptography.X509Certificates.RSACertificateExtensions]::GetRSAPrivateKey($_))) { throw $script:LocalizedData.NewJwtToken.Error.NoPrivateKey } else { $true } } else { throw $script:LocalizedData.NewJwtToken.Error.NotRsa } `|

## Outputs
**System.String**

Returns a String containing the raw token.
## Related Links
- [https://tools.ietf.org/html/rfc7519](https://tools.ietf.org/html/rfc7519)
- [https://jwt.io/](https://jwt.io/)
