function New-JwtToken
{
    <#
        .SYNOPSIS
            Creates a JWT token.
        .DESCRIPTION
            Creates a JWT token.
        .PARAMETER Algorithm
            A string containing the algorithm to use.
        .PARAMETER Type
            A string containing the token type.
        .PARAMETER Issuer
            A string containing the issuer to use.
        .PARAMETER Subject
            A string containing the subject to use.
        .PARAMETER Audience
            A string containing the audience to use.
        .PARAMETER Expiration
            An integer representing either the number of seconds for which the token will be valid, or the value of the UNIX epoch time when the token will not be valid anymore.
        .PARAMETER Claims
            An object, hastable or JSON string representing the claims to add or set to the header (based on reserved header claims) or payload.
            If a claim was already set using a parameter, it will be overriden.
            If algorithm (alg) is specified throught a claim, it will be ignored. Algorithm must be set by Algorithm parameter.
        .PARAMETER Secret
            A string, secure string or certificate private key (for RSA) used to sign the token.
        .PARAMETER KeyId
            A string containing the key ID.
        .PARAMETER Certificate
            An x509 certificate object used to sign the token if RSA algorithm is specified. The certificate object must contain the private key.
            Using a certificate implicitely adds the claim 'x5t' (Base64 encoded thumbprint of the certificate) to the header.
        .OUTPUTS
            System.String
            Returns a String containing the raw token.
        .EXAMPLE
            New-JwtToken -Algorithm HS256 -Issuer $TokenIssuer -Audience $TokenAudience -Secret $MySecret

            Description
            -----------
            This example will return a string containing the token.
        .EXAMPLE
            New-JwtToken -Algorithm RS256 -Claims @{ iss = $TokenIssuer ; aud = $TokenAudience } -Expiration 3600 -Secret $Cert.PrivateKey

            Description
            -----------
            This example will return a string containing the token.
        .EXAMPLE
            New-JwtToken -Algorithm RS256 -Claims '{"aud":"audience","iss":"issuer","sub":"subject"}' -Certificate (Get-ChildItem Cert:\LocalMachine\my\CERTIFICATETHUMBPRINT)

            Description
            -----------
            This example will return a string containing the token.
        .LINK
            https://tools.ietf.org/html/rfc7519
        .LINK
            https://jwt.io/
    #>
    [CmdLetBinding(DefaultParameterSetName = "FromSecret")]
    param(
        [Parameter(ParameterSetName = "FromSecret", Mandatory = $true)]
        [Parameter(ParameterSetName = "FromCertificate", Mandatory = $true)]
        [ValidateSet("HS256", "HS384", "HS512", "RS256", "RS384", "RS512")]
        [Alias("alg")]
        [string] $Algorithm,
        [Parameter(ParameterSetName = "FromSecret", Mandatory = $false)]
        [Parameter(ParameterSetName = "FromCertificate", Mandatory = $false)]
        [Alias("typ")]
        [string] $Type = "JWT",
        [Parameter(ParameterSetName = "FromSecret", Mandatory = $false)]
        [Parameter(ParameterSetName = "FromCertificate", Mandatory = $false)]
        [Alias("iss")]
        [string] $Issuer = "",
        [Parameter(ParameterSetName = "FromSecret", Mandatory = $false)]
        [Parameter(ParameterSetName = "FromCertificate", Mandatory = $false)]
        [Alias("sub")]
        [string] $Subject = "",
        [Parameter(ParameterSetName = "FromSecret", Mandatory = $false)]
        [Parameter(ParameterSetName = "FromCertificate", Mandatory = $false)]
        [Alias("aud")]
        [string] $Audience = "",
        [Parameter(ParameterSetName = "FromSecret", Mandatory = $false)]
        [Parameter(ParameterSetName = "FromCertificate", Mandatory = $false)]
        [Alias("exp", "val", "Validity", "ValidFor")]
        [int] $Expiration = 3600,
        [Parameter(ParameterSetName = "FromSecret", Mandatory = $false)]
        [Parameter(ParameterSetName = "FromCertificate", Mandatory = $false)]
        [Alias("c")]
        $Claims,
        [Parameter(ParameterSetName = "FromSecret", Mandatory = $true)]
        [ValidateScript({
            if (($Algorithm -like "RS*") -and ($_.GetType().FullName -ne "System.Security.Cryptography.AsymmetricAlgorithm")) { throw $script:LocalizedData.NewJwtToken.Error.NotPrivateKey }
            else { $true }
        })]
        [Alias("sec", "key", "pk")]
        $Secret,
        [Parameter(ParameterSetName = "FromSecret", Mandatory = $false)]
        [Alias("kid")]
        [string] $KeyId = "",
        [Parameter(ParameterSetName = "FromCertificate", Mandatory = $true)]
        [ValidateScript({
            if ($Algorithm -like "RS*")
            { 
                if (!$_.PrivateKey) { throw $script:LocalizedData.NewJwtToken.Error.NoPrivateKey }
                else { $true }
            }
            else { throw $script:LocalizedData.NewJwtToken.Error.NotRsa }
        })]
        [Alias("cert")]
        [X509Certificate2] $Certificate
    )

    begin
    {
        Write-Debug ($script:LocalizedData.Global.Debug.Entering -f $PSCmdlet.MyInvocation.MyCommand)
    }
    process
    {
        try
        {
            Write-Debug ($script:LocalizedData.NewJwtToken.Debug.BuildHeader -f $Algorithm)
            $Header = @{
                alg = $Algorithm;
                typ = $Type
            }
            
            if ($KeyId) { $Header.Add("kid", $KeyId) }
            if ($PSCmdlet.ParameterSetName -eq "FromCertificate")
            {
                $Secret = $Certificate.PrivateKey
                $Header.Add("x5t", [Convert]::ToBase64String([System.Text.Encoding]::ASCII.GetBytes($Certificate.Thumbprint)).Split('=')[0].Replace('+', '-').Replace('/', '_'))
            }

            if ((Get-Date "1970-01-01").AddSeconds($Expiration) -gt (Get-Date)) { $Expiry = $Expiration }
            else
            {
                Write-Debug ($script:LocalizedData.NewJwtToken.Debug.BuildExpiration -f $Expiration)
                $Expiry = Get-Date "$((Get-Date).AddSeconds($Expiration).ToUniversalTime())" -Uformat %s
                Write-Debug ($script:LocalizedData.NewJwtToken.Debug.Expiry -f $Expiry)
            }
            
            Write-Debug $script:LocalizedData.NewJwtToken.Debug.BuildPayload
            $Payload = @{
                exp = $Expiry
            }
            
            if ($Issuer) { $Payload.Add("iss", $Issuer) }
            if ($Subject) { $Payload.Add("sub", $Subject) }
            if ($Audience) { $Payload.Add("aud", $Audience) }
            
            if ($Claims)
            {
                Write-Debug ($script:LocalizedData.NewJwtToken.Debug.ClaimsType -f $Claims.GetType().Name)
                switch ($Claims.GetType().Name)
                {
                    "String"
                    {
                        try { $Claims = $Claims | ConvertFrom-Json -ErrorAction Stop }
                        catch { Write-Error -Message ($script:LocalizedData.NewJwtToken.Error.NotJson.Message -f $Claims) -Category InvalidData -CategoryActivity $MyInvocation.MyCommand -TargetType $script:LocalizedData.NewJwtToken.Error.NotJson.Target -TargetName $Claims -Exception InvalidDataException }
                    }
                    default { $Claims = $Claims | ConvertTo-Json -Compress | ConvertFrom-Json }
                }
                $Claims | Get-Member -MemberType NoteProperty | Where-Object { $Claims."$($_.Name)" -and ($_.Name -ne "alg") } | ForEach-Object {
                    $CurrentClaim = $_
                    Write-Verbose ($script:LocalizedData.NewJwtToken.Verbose.AddClaim -f $CurrentClaim.Name, $Claims."$($CurrentClaim.Name)")
                    if ($CurrentClaim.Name -in $Script:TokenHeaderClaims) 
                    {
                        if ($Header.Keys -contains $CurrentClaim.Name) { $Header[$CurrentClaim.Name] = $Claims."$($CurrentClaim.Name)" }
                        else { $Header.Add($CurrentClaim.Name, $Claims."$($CurrentClaim.Name)") }
                    }
                    else
                    {
                        if ($Payload.Keys -contains $CurrentClaim.Name) { $Payload[$CurrentClaim.Name] = $Claims."$($CurrentClaim.Name)" }
                        else { $Payload.Add($CurrentClaim.Name, $Claims."$($CurrentClaim.Name)") }
                    }
                }
            }

            $Header = $Header | ConvertTo-Json -Compress
            $Payload = $Payload | ConvertTo-Json -Compress
            Write-Debug ($script:LocalizedData.NewJwtToken.Debug.HeaderToJson -f $Header)
            Write-Debug ($script:LocalizedData.NewJwtToken.Debug.PayloadToJson -f $Payload)
            
            if ($Secret.GetType().Name -eq "SecureString")
            {
                Write-Debug $script:LocalizedData.NewJwtToken.Debug.SecretAsString
                $Credential = New-Object -TypeName pscredential("jwt", $Secret)
                $Secret = $Credential.GetNetworkCredential().Password
            }
            
            $EncodedHeader = [Convert]::ToBase64String([System.Text.Encoding]::ASCII.GetBytes($Header)).Split('=')[0].Replace('+', '-').Replace('/', '_')
            $EncodedPayload = [Convert]::ToBase64String([System.Text.Encoding]::ASCII.GetBytes($Payload)).Split('=')[0].Replace('+', '-').Replace('/', '_')
            Write-Debug ($script:LocalizedData.NewJwtToken.Debug.HeaderToBase64 -f $EncodedHeader)
            Write-Debug ($script:LocalizedData.NewJwtToken.Debug.PayloadToBase64 -f $EncodedPayload)

            $ToBeSigned = "$EncodedHeader.$EncodedPayload"

            $SigningAlgorithm = switch ($Algorithm)
            {
                "HS256" { New-Object System.Security.Cryptography.HMACSHA256 }
                "HS384" { New-Object System.Security.Cryptography.HMACSHA384 }
                "HS512" { New-Object System.Security.Cryptography.HMACSHA512 }
                "RS256" { [Security.Cryptography.HashAlgorithmName]::SHA256 }
                "RS384" { [Security.Cryptography.HashAlgorithmName]::SHA384 }
                "RS512" { [Security.Cryptography.HashAlgorithmName]::SHA512 }
            }

            switch -Regex ($Algorithm)
            {
                "HS"
                {
                    $SigningAlgorithm.Key = [System.Text.Encoding]::ASCII.GetBytes($Secret)
                    $Signature = $SigningAlgorithm.ComputeHash([System.Text.Encoding]::ASCII.GetBytes($ToBeSigned))
                }
                "RS"
                {
                    $Signature = $Secret.SignData($ToBeSigned, $SigningAlgorithm, [Security.Cryptography.RSASignaturePadding]::Pkcs1)
                }
            }
            
            $Signature = [Convert]::ToBase64String($Signature).Split('=')[0].Replace('+', '-').Replace('/', '_')
            Write-Debug ($script:LocalizedData.NewJwtToken.Debug.Signature -f $Signature)
            $Token = "$EncodedHeader.$EncodedPayload.$Signature"
            $Token
        }
        catch
        {
            Write-Error $_
        }
    }
    end
    {
        Write-Debug ($script:LocalizedData.Global.Debug.Leaving -f $PSCmdlet.MyInvocation.MyCommand)
    }
}