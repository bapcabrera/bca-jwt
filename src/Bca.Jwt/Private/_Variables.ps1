[string] $Script:TokenValidationRegex = "^eyJ[a-zA-Z0-9\-_]+?\.eyJ[a-zA-Z0-9\-_]+?\.([a-zA-Z0-9\-_\*]+)?$"
[string[]] $Script:TokenPartNames = "Header", "Payload", "Signature"
[string[]] $Script:TokenPayloadDatesFields = "nbf", "exp", "auth_time", "iat"

[string[]] $Script:TokenHeaderClaims = "alg", "cty", "typ", "jku", "kid", "x5u", "x5t", "crit"