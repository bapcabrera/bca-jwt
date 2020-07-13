function Test-JwtToken
{
    <#
        .SYNOPSIS
            Tests a JWT token vailidty.
        .DESCRIPTION
            Tests a JWT raw token vailidty.
        .PARAMETER Token
            A string containing the raw JWT token.
        .OUTPUTS
            System.Boolean
            Returns a Boolean specifying if the token is valide.
        .LINK
            https://tools.ietf.org/html/rfc7519
        .LINK
            https://jwt.io/
    #>
    [CmdLetBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string] $Token
    )

    Write-Debug ($script:LocalizedData.Global.Debug.Entering -f $PSCmdlet.MyInvocation.MyCommand)
    Write-Debug ($script:LocalizedData.TestjwtToken.Debug.Token -f $Token)
    Write-Debug ($script:LocalizedData.TestjwtToken.Debug.Regex -f $Script:TokenValidationRegex)
    $Token -match $Script:TokenValidationRegex
    Write-Debug ($script:LocalizedData.Global.Debug.Leaving -f $PSCmdlet.MyInvocation.MyCommand)
}