@{
    Global                      = @{
        Debug = @{
            Entering = "Début de la fonction « {0} »"
            Leaving  = "Fin de la fonction « {0} »"
        }
    }

    ImportModule                = @{
        Error = @{
            ImportError = @{
                Message = "Impossible d'importer la fonction « {0} »  : {1}"
                Target  = "Fonction"
            }
        }
    }

    ConvertFromJwtToken         = @{
        Verbose = @{
            ConvertToBase64      = "Conversion de {0} depuis Base64."
            ConvertFromUnixEpoch = "Conversion de '{0}' depuis date UNIX."
        }
        Debug   = @{
            TokenBefore       = "Token avant : {0}"
            TokenAfter        = "Token après : {0}"
            PartBeforePadding = "{0} avant padding : {1}"
            PartAfterPadding  = "{0} après padding : {1}"
            PartAsJson        = "{0} en JSON : {1}"
            DateBefore        = "« {0} » avant : {1}"
            DateAfter         = "« {0} » après : {1}"
        }
        Error   = @{
            InvalidToken = "Le format du token « {0} » est invalide."
        }
    }
    ConvertToJwtToken           = @{
        Verbose = @{
            Processing         = "Traitement de {0}"
            ConvertToUnixEpoch = "Convrsion de « {0} » en date UNIX."
            ConvertToJson      = "Conversion de {0} en JSON."
            ConvertToBase64    = "Conversion de {0} en Base64."
            
        }
        Debug   = @{
            BodyIsJson   = "Le corps est JSON : {0}"
            DateType     = "{0} type : {1}"
            DateBefore   = "« {0} » avant : {1}"
            DateAfter    = "« {0} » après : {1}"
            PartBefore   = "{0} avant : {1}"
            PartAfter    = "{0} après : {1}"
            PartUnpadded = "{0} sans padding : {1}"
        }
        Error   = @{
            MissingMember = "Un membre est manquant dans le token."
        }
    }
    GetJwtTokenPart             = @{
        Debug = @{
            Parts = "Nom de la partie : {0}"
        }
    }
    GetJwtTokenPayloadDateField = @{
        Debug = @{
            Dates = "Dates : {0}"
        }
    }
    NewJwtToken                 = @{
        Debug   = @{
            BuildHeader     = "Création du header avec algoritme « {0} »."
            BuildExpiration = "Création de l'expiration de {0} secondes."
            Expiry          = "L'expiration en date UNIX UTC est {0}."
            BuildPayload    = "Création du payload."
            ClaimsType      = "Type des demandes : {0}"
            HeaderToJson    = "Header en JSON : {0}"
            PayloadToJson   = "Payload en JSON : {0}"
            HeaderToBase64  = "Header en Base64 : {0}"
            PayloadToBase64 = "Payload en Base64 : {0}"
            SecretAsString  = "Conversion du secret depuis SecureString."
            Signature       = "Signature : {0}"
        }
        Verbose = @{
            AddClaim = "Paramétrage de la demande « {0} » avec la valeur « {1} »."
        }
        Error   = @{
            NotPrivateKey = "L'algoritme RSA requiert que le secret soit la clé privée du certificat (System.Security.Cryptography.AsymmetricAlgorithm)."
            NotJson       = @{
                Message = "La chaine de charactères « {0} » n'est pas un JSON valide."
                Target  = "Demandes"
            }
        }
    }
    TestJwtToken                = @{
        Debug = @{
            Token = "Token : {0}"
            Regex = "Expression régulière de validation : {0}"
        }
    }
}