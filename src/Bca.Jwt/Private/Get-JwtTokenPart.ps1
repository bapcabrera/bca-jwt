function Get-JwtTokenPart
{
    <#
        .SYNOPSIS
            Gets the names of a JWT token parts.
        .DESCRIPTION
            Gets the names of a JWT token parts.
        .LINK
            https://tools.ietf.org/html/rfc7519
        .LINK
            https://jwt.io/
    #>
    [CmdLetBinding()]
    param()

    Write-Debug ($script:LocalizedData.Global.Debug.Entering -f $PSCmdlet.MyInvocation.MyCommand)
    Write-Debug ($script:LocalizedData.GetJwtTokenPart.Debug.Parts -f ($Script:TokenPartNames -join ", "))
    $Script:TokenPartNames
    Write-Debug ($script:LocalizedData.Global.Debug.Leaving -f $PSCmdlet.MyInvocation.MyCommand)
}