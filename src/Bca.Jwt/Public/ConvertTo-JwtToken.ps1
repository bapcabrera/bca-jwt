function ConvertTo-JwtToken
{
    <#
        .SYNOPSIS
            Converts a JWT token object.
        .DESCRIPTION
            Converts a JWT token object to a string.
        .PARAMETER Token
            An object containing the token.
        .INPUTS
            System.Management.Automation.PSCustomObject
            You can pipe an object for the token to this cmdlet.
        .OUTPUTS
            System.String
            Returns a String containing the raw token.
        .EXAMPLE
            ConvertTo-JwtToken -Token $MyTokenObject

            Description
            -----------
            This example will return a string containing the raw token.
        .EXAMPLE
            $MyTokenObject | ConvertTo-JwtToken

            Description
            -----------
            This example will return a string containing the raw token.
        .NOTES
            If signature is offuscated the token will not be valid. 
        .LINK
            ConvertFrom-JwtToken
        .LINK
            https://tools.ietf.org/html/rfc7519
        .LINK
            https://jwt.io/
    #>
    [CmdLetBinding()]
    param(
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [ValidateNotNullOrEmpty()]
        [ValidateScript( { if (!$_.Header -or !$_.Payload -or !$_.Signature) { throw $script:LocalizedData.ConvertToJwtToken.Error.MissingMember } else { $true } })]
        [pscustomobject] $Token
    )
 
    begin
    {
        Write-Debug ($script:LocalizedData.Global.Debug.Entering -f $PSCmdlet.MyInvocation.MyCommand)
        $PartNames = Get-JwtTokenPart
    }
    process
    {
        try
        {
            if ($Token)
            {
                $Parts = @()
                
                $PartNames | ForEach-Object {
                    Write-verbose ($script:LocalizedData.ConvertToJwtToken.Verbose.Processing -f $_.ToLower())
                    $Part = $Token.$_
                    if ($_ -ne "Signature")
                    {
                        $JsonBody = $false
                        
                        try
                        {
                            $Part | ConvertFrom-Json -ErrorAction Stop | Out-Null
                            $JsonBody = $true
                        }
                        catch
                        {
                            $JsonBody = $false
                        }
                        
                        Write-Debug ($script:LocalizedData.ConvertToJwtToken.Debug.BodyIsJson -f $JsonBody)
                        if (!$JsonBody)
                        {
                            if ($_ -eq "Payload")
                            {
                                Get-JwtTokenPayloadDateField | Where-Object { $Part.$_ } | ForEach-Object {
                                    Write-Debug ($script:LocalizedData.ConvertToJwtToken.Debug.DateType -f $_, $Part.$_.GetType().Name)
                                    if ($Part.$_.GetType().Name -eq "DateTime")
                                    {
                                        Write-Verbose ($script:LocalizedData.ConvertToJwtToken.Verbose.ConvertToUnixEpoch -f $_)
                                        Write-Debug ($script:LocalizedData.ConvertToJwtToken.Debug.DateBefore -f $_, $Part.$_)
                                        [int32] $Part.$_ = (New-TimeSpan -Start (Get-Date "1970-01-01") -End $Part.$_).TotalSeconds
                                        Write-Debug ($script:LocalizedData.ConvertToJwtToken.Debug.DateAfter -f $_, $Part.$_)
                                    }
                                }
                            }
                            Write-Verbose ($script:LocalizedData.ConvertToJwtToken.Verbose.ConvertToJson -f $_.ToLower())
                            $Part = $Part | ConvertTo-Json -Compress
                        }
                        Write-Verbose ($script:LocalizedData.ConvertToJwtToken.Verbose.ConvertToBase64 -f $_.ToLower())
                        Write-Debug ($script:LocalizedData.ConvertToJwtToken.Debug.PartBefore -f $_, $Part)
                        $Part = [system.convert]::ToBase64String([System.Text.Encoding]::ASCII.GetBytes($Part.Split("=")[0]))
                        Write-Debug ($script:LocalizedData.ConvertToJwtToken.Debug.PartAfter -f $_, $Part)
                    }
                    Write-Debug ($script:LocalizedData.ConvertToJwtToken.Debug.PartUnpadded -f $_, $Part.Replace("=", "").Replace('+', '-').Replace('/', '_'))
                    $Parts += $Part.Replace("=", "").Replace('+', '-').Replace('/', '_')
                }
                $Parts -join '.'
            }
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
