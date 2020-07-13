function Get-JwtTokenPayloadDateField
{
    <#
        .SYNOPSIS
            Gets the field names of a JWT token part that are dates.
        .DESCRIPTION
            Gets the field names of a JWT token part that are dates.
        .LINK
            https://tools.ietf.org/html/rfc7519
        .LINK
            https://jwt.io/
    #>
    [CmdLetBinding()]
    param()

    Write-Debug ($script:LocalizedData.Global.Debug.Entering -f $PSCmdlet.MyInvocation.MyCommand)
    Write-Debug ($script:LocalizedData.GetJwtTokenPayloadDateField.Debug.Dates -f ($Script:TokenPayloadDatesFields -join ", "))
    $Script:TokenPayloadDatesFields
    Write-Debug ($script:LocalizedData.Global.Debug.Leaving -f $PSCmdlet.MyInvocation.MyCommand)
}
