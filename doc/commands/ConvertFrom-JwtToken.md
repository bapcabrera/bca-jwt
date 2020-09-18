# ConvertFrom-JwtToken
Type: Function

Module: [Bca.Jwt](../ReadMe.md)

Converts a JWT token string.
## Description
Converts a JWT token string to an object containing members representing the header, payload and signature of the raw token.
## Syntax
```powershell
ConvertFrom-JwtToken [-Token] <string> [-AsJson] [-ConvertDate] [<CommonParameters>]
```
## Examples
### Example 1
```powershell
ConvertFrom-JwtToken -Token $MyRawToken
```
This example will return an object representing the token.
### Example 2
```powershell
ConvertFrom-JwtToken -Token $MyRawToken -AsJson
```
This example will return an object representing the token with header and payload as JSON.
### Example 3
```powershell
$MyRawToken | ConvertFrom-JwtToken -ConvertDate
```
This example will return an object representing the token dates converted from seconds since Unix epoch to DateTime.
## Parameters
### `-Token`
A string containing the raw JWT token.

| | |
|:-|:-|
|Type:|String|
|Position:|0|
|Required:|True|
|Accepts pipepline input:|True|
|Validation (ScriptBlock):|` if (!(Test-JwtToken -Token $_)) { throw ($script:LocalizedData.ConvertFromJwtToken.Error.InvalidToken -f $_) } else { $true } `|

### `-AsJson`
A switch specifying whether or not to return the parts as JSON (except the signature).

| | |
|:-|:-|
|Type:|SwitchParameter|
|Default value:|False|
|Position:|Named|
|Required:|False|
|Accepts pipepline input:|False|

### `-ConvertDate`
A switch specifying whether or not to convert the date from seconds since Unix epoch to DateTime (affected fields are 'nbf', 'exp' and 'auth_time' in the payload).
This parameter has no effect if AsJson is specified.

| | |
|:-|:-|
|Type:|SwitchParameter|
|Default value:|False|
|Position:|Named|
|Required:|False|
|Accepts pipepline input:|False|

## Inputs
**System.String**

You can pipe a value for the raw token to this cmdlet.
## Outputs
**System.Management.Automation.PSCustomObject**

Returns a PSCustomObject containing a description of the token.
## Notes
Signature is kept raw but padded, so it can be offuscated if needed.
## Related Links
- [ConvertTo-JwtToken](ConvertTo-JwtToken.md)
- [https://tools.ietf.org/html/rfc7519](https://tools.ietf.org/html/rfc7519)
- [https://jwt.io/](https://jwt.io/)
