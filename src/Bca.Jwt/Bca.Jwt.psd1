
@{

    # Script module or binary module file associated with this manifest.
    RootModule = 'Bca.Jwt'

    # Version number of this module.
    ModuleVersion = '0.0.2'

    # Supported PSEditions
    # CompatiblePSEditions = @()

    # ID used to uniquely identify this module
    GUID = '28fc42d6-f63e-4433-8817-9d6a32f03c0d'

    # Author of this module
    Author = 'Baptiste Cabrera'

    # Company or vendor of this module
    CompanyName = 'Bca'

    # Copyright statement for this module
    Copyright = '(c) 2020 Bca. All rights reserved.'

    # Description of the functionality provided by this module
    Description = 'Module to manage JWT tokens.'

    # Minimum version of the Windows PowerShell engine required by this module
    PowerShellVersion = '5.1'

    # Name of the Windows PowerShell host required by this module
    # PowerShellHostName = ''

    # Minimum version of the Windows PowerShell host required by this module
    # PowerShellHostVersion = ''

    # Minimum version of Microsoft .NET Framework required by this module. This prerequisite is valid for the PowerShell Desktop edition only.
    # DotNetFrameworkVersion = ''

    # Minimum version of the common language runtime (CLR)required by this module. This prerequisite is valid for the PowerShell Desktop edition only.
    # CLRVersion = ''

    # Processor architecture (None, X86, Amd64)required by this module
    # ProcessorArchitecture = ''

    # Modules that must be imported into the global environment prior to importing this module
    # RequiredModules = @()

    # Assemblies that must be loaded prior to importing this module
    # RequiredAssemblies = @()

    # Script files (.ps1)that are run in the caller's environment prior to importing this module.
    # ScriptsToProcess = @()

    # Type files (.ps1xml) to be loaded when importing this module
    # TypesToProcess = @()

    # Format files (.ps1xml) to be loaded when importing this module
    # FormatsToProcess = @()

    # Modules to import as nested modules of the module specified in RootModule/ModuleToProcess
    # NestedModules = @()

    # Functions to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no functions to export.
    # FunctionsToExport = @()

    # Cmdlets to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no cmdlets to export.
    # CmdletsToExport   = @()

    # Variables to export from this module
    # VariablesToExport = ' * '

    # Aliases to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no aliases to export.
    # AliasesToExport   = @()

    # DSC resources to export from this module
    # DscResourcesToExport = @()

    # List of all modules packaged with this module
    # ModuleList = @()

    # List of all files packaged with this module
    # FileList = @()

    # Private data to pass to the module specified in RootModule/ModuleToProcess. This may also contain a PSData hashtable with additional module metadata used by PowerShell.
    PrivateData       = @{

        PSData = @{

            # Tags applied to this module. These help with module discovery in online galleries.
            Tags = @('jwt', 'jsonwebtoken', 'token', 'jwttoken')

            # A URL to the license for this module.
            # LicenseUri = ''

            # A URL to the main website for this project.
            ProjectUri = 'https://github.com/bapcabrera/bca-jwt'

            # A URL to an icon representing this module.
            # IconUri = ''

            # ReleaseNotes of this module
            ReleaseNotes = '0.0.2:
- New-JwToken: Added parameter Certificate to sign token with a certificate when using RSA algorithms, the certificate nust contain the private key.
- New-JwToken: Added new common optional parameters (such as Type, KeyId and Subject).
- New-JwToken: Expiration parameter can now either a number of seconds for which the token is valid, or the UNIX date until which the token will be valid.
- New-JwToken: Fixed empty optional parameters, if optional parameters are not provided, they will be omitted instead of being empty.

0.0.1:
- First Version
- New-JwtToken: Function to create a JWT token (support HS256, HS384, HS512, RS256, RS384, RS512 so far).
- ConvertFrom-JwtToken: Function to convert a raw JWT token to an object.
- ConvertTo-JwtToken: Function to convert a token object to raw JWT token.
- Test-JwtToken: Function to test is a jwt token is structuraly valid.'

        } # End of PSData hashtable

    } # End of PrivateData hashtable

    # HelpInfo URI of this module
    # HelpInfoURI = ''

    # Default prefix for commands exported from this module. Override the default prefix using Import-Module -Prefix.
    # DefaultCommandPrefix = ''

}

