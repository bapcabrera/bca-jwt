function ConvertFrom-JwtToken
{
    <#
        .SYNOPSIS
            Converts a JWT token string.
        .DESCRIPTION
            Converts a JWT token string to an object containing members representing the header, payload and signature of the raw token.
        .PARAMETER Token
            A string containing the raw JWT token.
        .PARAMETER AsJson
            A switch specifying whether or not to return the parts as JSON (except the signature).
        .PARAMETER ConvertDate
            A switch specifying whether or not to convert the date from seconds since Unix epoch to DateTime (affected fields are 'nbf', 'exp' and 'auth_time' in the payload).
            This parameter has no effect if AsJson is specified.
        .INPUTS
            System.String
            You can pipe a value for the raw token to this cmdlet.
        .OUTPUTS
            System.Management.Automation.PSCustomObject
            Returns a PSCustomObject containing a description of the token.
        .EXAMPLE
            ConvertFrom-JwtToken -Token $MyRawToken

            Description
            -----------
            This example will return an object representing the token.
        .EXAMPLE
            ConvertFrom-JwtToken -Token $MyRawToken -AsJson

            Description
            -----------
            This example will return an object representing the token with header and payload as JSON.
        .EXAMPLE
            $MyRawToken | ConvertFrom-JwtToken -ConvertDate

            Description
            -----------
            This example will return an object representing the token dates converted from seconds since Unix epoch to DateTime.
        .NOTES
            Signature is kept raw but padded, so it can be offuscated if needed. 
        .LINK
            ConvertTo-JwtToken
        .LINK
            https://tools.ietf.org/html/rfc7519
        .LINK
            https://jwt.io/
    #>
    [CmdLetBinding()]
    param(
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [ValidateNotNullOrEmpty()]
        [ValidateScript( { if (!(Test-JwtToken -Token $_)) { throw ($script:LocalizedData.ConvertFromJwtToken.Error.InvalidToken -f $_) } else { $true } })]
        [string] $Token,
        [Parameter(Mandatory = $false)]
        [switch] $AsJson,
        [Parameter(Mandatory = $false)]
        [switch] $ConvertDate
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
                Write-Debug ($script:LocalizedData.ConvertFromJwtToken.Debug.TokenBefore -f $Token)
                $Token = $Token.Replace('-', '+').Replace('_', '/')
                Write-Debug ($script:LocalizedData.ConvertFromJwtToken.Debug.TokenAfter -f $Token)
                $TokenObject = New-Object -TypeName psobject
                
                $i = 0
                $Token.Split(".") | ForEach-Object {
                    $Part = $_
                    Write-Debug ($script:LocalizedData.ConvertFromJwtToken.Debug.PartBeforePadding -f $PartNames[$i], $Part)
                    while ($Part.Length % 4) { $Part += "=" }
                    Write-Debug ($script:LocalizedData.ConvertFromJwtToken.Debug.PartAfterPadding -f $PartNames[$i], $Part)
                    if ($PartNames[$i] -ne "Signature")
                    {
                        Write-Verbose ($script:LocalizedData.ConvertFromJwtToken.Verbose.ConvertToBase64 -f $PartNames[$i].ToLower())
                        $Part = [System.Text.Encoding]::ASCII.GetString([system.convert]::FromBase64String($Part))
                        Write-Debug ($script:LocalizedData.ConvertFromJwtToken.Debug.PartAsJson -f $PartNames[$i], $Part)
                        if (!$AsJson) { $Part = $Part | ConvertFrom-Json }
                        if (($PartNames[$i] -eq "Payload") -and $ConvertDate -and !$AsJson)
                        {
                            Get-JwtTokenPayloadDateField | Where-Object { $Part.$_ } | ForEach-Object { 
                                Write-Verbose ($script:LocalizedData.ConvertFromJwtToken.Verbose.ConvertFromUnixEpoch -f $_)
                                Write-Debug ($script:LocalizedData.ConvertFromJwtToken.Debug.DateBefore -f $_, $Part.$_)
                                $Part.$_ = (Get-Date "1970-01-01").AddSeconds($Part.$_)
                                Write-Debug ($script:LocalizedData.ConvertFromJwtToken.Debug.DateAfter -f $_, $Part.$_)
                            }
                        }
                    }
                    $TokenObject | Add-Member -MemberType NoteProperty -Name $PartNames[$i] -Value $Part | Out-Null
                    $i++
                }
                
                $TokenObject
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