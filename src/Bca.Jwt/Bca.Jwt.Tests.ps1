if (Test-Path (Join-Path $PSScriptRoot LocalizedData))
{
    $global:TestLocalizedData = Import-LocalizedData -BaseDirectory (Join-Path $PSScriptRoot LocalizedData) -ErrorAction SilentlyContinue
    if (!$?) { $global:TestLocalizedData = Import-LocalizedData -UICulture en-US -BaseDirectory (Join-Path $PSScriptRoot LocalizedData) }
}

Describe $global:TestLocalizedData.Module.Describe {
    It $global:TestLocalizedData.Module.ImportModule {
        try
        {
            Import-Module (Join-Path $PSScriptRoot Bca.Jwt.psd1) -Force
            $Result = $true
        }
        catch { $Result = $false }
        $Result | Should -Be $true
    }
    
    It $global:TestLocalizedData.Module.CommandCheck {
        $Commands = Get-Command -Module Bca.Jwt
        $Commands.Count | Should -BeGreaterThan 0
    }
}

Describe $global:TestLocalizedData.Token.Describe {
    
    BeforeAll {
        $TokenIssuer = "Bca"
        $TokenAudience = "Everyone"
        $policies = [System.Security.Cryptography.CngExportPolicies]::AllowPlaintextExport, [System.Security.Cryptography.CngExportPolicies]::AllowExport
        $Certificate = New-SelfSignedCertificate -CertStoreLocation Cert:\CurrentUser\My\ -HashAlgorithm "SHA256" -KeyLength 2048 -KeyAlgorithm RSA -KeyUsage DigitalSignature -KeyExportPolicy $Policies -Subject "BcaJwt"
        $PrivateKey = [System.Security.Cryptography.X509Certificates.RSACertificateExtensions]::GetRSAPrivateKey($Certificate)
        $Secret = "shush!"
    }
    
    It $global:TestLocalizedData.Token.NewHS256 {
        try
        {
            $Result = $true
            $Token = New-JwtToken -Algorithm HS256 -Issuer $TokenIssuer -Audience $TokenAudience -Secret $Secret
        }
        catch { $Result = $false }
        $Result | Should -Be $true
        $Token | Should -Not -Be ""
    }
    
    It $global:TestLocalizedData.Token.NewRS256Cert {
        try
        {
            $Result = $true
            $Token = New-JwtToken -Algorithm RS256 -Issuer $TokenIssuer -Audience $TokenAudience -Certificate $Certificate
        }
        catch { $Result = $false }
        $Result | Should -Be $true
        $Token | Should -Not -Be ""
    }
    
    It $global:TestLocalizedData.Token.NewRS256PrivateKey {
        try
        {
            $Result = $true
            $Token = New-JwtToken -Algorithm RS256 -Issuer $TokenIssuer -Audience $TokenAudience -Secret $PrivateKey
        }
        catch { $Result = $false }
        $Result | Should -Be $true
        $Token | Should -Not -Be ""
    }
    
    It $global:TestLocalizedData.Token.ConvertFrom {
        try
        {
            $Result = $true
            $Token = New-JwtToken -Algorithm HS256 -Issuer $TokenIssuer -Audience $TokenAudience -Secret $Secret
            $TokenObject = $Token | ConvertFrom-JwtToken
        }
        catch { $Result = $false }
        $Result | Should -Be $true
        $TokenObject.Payload.iss | Should -BeExactly $TokenIssuer
        $TokenObject.Payload.aud | Should -BeExactly $TokenAudience
    }
    
    It $global:TestLocalizedData.Token.ConvertTo {
        try
        {
            $Result = $true
            $Token = New-JwtToken -Algorithm HS256 -Issuer $TokenIssuer -Audience $TokenAudience -Secret $Secret
            $Token2 = $Token | ConvertFrom-JwtToken | ConvertTo-JwtToken
        }
        catch { $Result = $false }
        $Result | Should -Be $true
        $Token2 | Should -BeExactly $Token
    }
}
