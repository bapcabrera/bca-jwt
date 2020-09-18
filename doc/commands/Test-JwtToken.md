# Test-JwtToken
Type: Function

Module: [Bca.Jwt](../ReadMe.md)

Tests a JWT token vailidty.
## Description
Tests a JWT raw token vailidty.
## Syntax
```powershell
Test-JwtToken [-Token] <string> [<CommonParameters>]
```
## Parameters
### `-Token`
A string containing the raw JWT token.

| | |
|:-|:-|
|Type:|String|
|Position:|0|
|Required:|True|
|Accepts pipepline input:|False|

## Outputs
**System.Boolean**

Returns a Boolean specifying if the token is valide.
## Related Links
- [https://tools.ietf.org/html/rfc7519](https://tools.ietf.org/html/rfc7519)
- [https://jwt.io/](https://jwt.io/)
