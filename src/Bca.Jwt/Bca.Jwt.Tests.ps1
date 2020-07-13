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
    }
    
    It $global:TestLocalizedData.Token.New {
        try
        {
            $Result = $true
            $Token = New-JwtToken -Algorithm HS256 -Issuer $TokenIssuer -Audience $TokenAudience -Secret "shush"
        }
        catch { $Result = $false }
        $Result | Should -Be $true
        $Token | Should -Not -Be ""
    }
    
    It $global:TestLocalizedData.Token.ConvertFrom {
        try
        {
            $Result = $true
            $Token = New-JwtToken -Algorithm HS256 -Issuer $TokenIssuer -Audience $TokenAudience -Secret "shush"
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
            $Token = New-JwtToken -Algorithm HS256 -Issuer $TokenIssuer -Audience $TokenAudience -Secret "shush"
            $Token2 = $Token | ConvertFrom-JwtToken | ConvertTo-JwtToken
        }
        catch { $Result = $false }
        $Result | Should -Be $true
        $Token2 | Should -BeExactly $Token
    }
}
