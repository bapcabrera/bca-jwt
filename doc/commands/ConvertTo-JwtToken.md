# ConvertTo-JwtToken
Type: Function
Module: [Bca.Jwt](../ReadMe.md)

Converts a JWT token object.
## Description
Converts a JWT token object to a string.
## Syntax
```powershell
ConvertTo-JwtToken [-Token] <psobject> [<CommonParameters>]
```
## Examples
### Example 1
```powershell
ConvertTo-JwtToken -Token $MyTokenObject
```
This example will return a string containing the raw token.
### Example 2
```powershell
$MyTokenObject | ConvertTo-JwtToken
```
This example will return a string containing the raw token.
## Parameters
### `-Token`
An object containing the token.

| | |
|:-|:-|
|Type:|PSObject|
|Position:|0|
|Required:|True|
|Accepts pipepline input:|True|
|Validation (ScriptBlock):|` if (!$_.Header -or !$_.Payload -or !$_.Signature) { throw $script:LocalizedData.ConvertToJwtToken.Error.MissingMember } else { $true } `|

## Inputs
**System.Management.Automation.PSCustomObject**
You can pipe an object for the token to this cmdlet.
## Outputs
**System.String**
Returns a String containing the raw token.
## Notes
If signature is offuscated the token will not be valid.
## Related Links
- [ConvertFrom-JwtToken](ConvertFrom-JwtToken.md)
- [https://tools.ietf.org/html/rfc7519](https://tools.ietf.org/html/rfc7519)
- [https://jwt.io/](https://jwt.io/)
