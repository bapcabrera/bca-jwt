@{
    Global                      = @{
        Debug = @{
            Entering = "Entering '{0}'"
            Leaving  = "Leaving '{0}'"
        }
    }

    ImportModule                = @{
        Error = @{
            ImportError = @{
                Message = "Failed to import function '{0}': {1}"
                Target  = "Function"
            }
        }
    }

    ConvertFromJwtToken         = @{
        Verbose = @{
            ConvertToBase64      = "Converting {0} from Base64 string."
            ConvertFromUnixEpoch = "Converting '{0}' from UNIX epoch."
        }
        Debug   = @{
            TokenBefore       = "Token before: {0}"
            TokenAfter        = "Token after: {0}"
            PartBeforePadding = "{0} before padding: {1}"
            PartAfterPadding  = "{0} after padding: {1}"
            PartAsJson        = "{0} as JSON: {1}"
            DateBefore        = "'{0}' before: {1}"
            DateAfter         = "'{0}' after: {1}"
        }
        Error   = @{
            InvalidToken = "Token '{0}' format is invalid."
        }
    }
    ConvertToJwtToken           = @{
        Verbose = @{
            Processing         = "Processing {0}"
            ConvertToUnixEpoch = "Converting '{0}' to UNIX epoch."
            ConvertToJson      = "Converting {0} to JSON."
            ConvertToBase64    = "Converting {0} to Base64."
            
        }
        Debug   = @{
            BodyIsJson   = "Body is JSON: {0}"
            DateType     = "{0} type: {1}"
            DateBefore   = "'{0}' before: {1}"
            DateAfter    = "'{0}' after: {1}"
            PartBefore   = "{0} before: {1}"
            PartAfter    = "{0} after: {1}"
            PartUnpadded = "{0} unpadded: {1}"
        }
        Error   = @{
            MissingMember = "Token object is missing a member."
        }
    }
    GetJwtTokenPart             = @{
        Debug = @{
            Parts = "Part names: {0}"
        }
    }
    GetJwtTokenPayloadDateField = @{
        Debug = @{
            Dates = "Dates: {0}"
        }
    }
    NewJwtToken                 = @{
        Debug   = @{
            BuildHeader     = "Building header with algorithm '{0}'."
            BuildExpiration = "Building expiration with {0} seconds."
            Expiry          = "Expiration in UTC UNIX epoch is {0}."
            BuildPayload    = "Building payload."
            ClaimsType      = "Claims type: {0}"
            HeaderToJson    = "Header to JSON: {0}"
            PayloadToJson   = "Payload to JSON: {0}"
            HeaderToBase64  = "Header to Base64: {0}"
            PayloadToBase64 = "Payload to Base64: {0}"
            SecretAsString  = "Converting secret from SecureString."
            Signature       = "Signature: {0}"
        }
        Verbose = @{
            AddClaim = "Setting claim '{0}' with value '{1}'."
        }
        Error   = @{
            NotPrivateKey = "RSA algorithm requires a certificate private key (System.Security.Cryptography.AsymmetricAlgorithm) as the secret."
            NotJson       = @{
                Message = "The string '{0}' is not a valid JSON string."
                Target  = "Claims"
            }
        }
    }
    TestJwtToken                = @{
        Debug = @{
            Token = "Token: {0}"
            Regex = "Validation regex: {0}"
        }
    }
}