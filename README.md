# Bca.Jwt

## Description

_Bca.Jwt_ is a PowerShell module used to interract with _JSON Web Token_ (JWT).

It can be used to create new tokens, test tokens, convert a raw token to an object to check properties, and back to a token.

## Disclaimer

- _Bca.Jwt_ has been created to answer my needs, but I provide it to people who may need such a tool.
- So far, only RS and HS algorithms are supported:
  - HS algorithm tokens are signed with a secret
  - RS algorithm tokens can be signed either by specifying the certificate private key, or the certificate containing its private key
- It may contain bugs or lack some features, in this case, feel free to open an issue, and I'll manage it as best as I can.
- This _GitHub_ repository is not the primary one, but you are welcome to contribute, see transparency for more information.

## Examples

### Convert a raw token to an object

```ps
"eyJxxxxx.eyJyyyyyy.zzzzzz" | ConvertFrom-JwtToken
```

### Convert a token object to raw token

```ps
$TokenObject = "eyJxxxxx.eyJyyyyyy.zzzzzz" | ConvertFrom-JwtToken
$TokenObject | ConvertTo-JwtToken
```

## How to install

### The easiest way

In a PowerShell console, run the following:
```ps
Find-Module -Name Bca.Jwt | Install-Module
```

### Package

_Bca.Jwt_ is available as a package from _[PowerShell Gallery](https://www.powershellgallery.com/)_, _[NuGet](https://www.nuget.org/)_ and _[Chocolatey](https://chocolatey.org/)_, please refer to each specific plateform on how to install the package.

\* Chocolatey feed may not be up to date as there are manual verifications for each packages.

### Manually

If you decide to install _Bca.Jwt_ manually, copy the content of `src` into one or all of the path(s) contained in the variable `PSModulePath` depending on the scope you need.

I'll advise you use a path with the version, that can be found in the module manifest `psd1` file (e.g. `C:\Program Files\WindowsPowerShell\Modules\Bca.Jwt\1.0.0`). In that case copy the content of `src/Bca.Jwt` in this path.

## Transparency

_Please not that to date I am the only developper for this module._

- All code is primarily stored on a private Git repository on Azure DevOps;
- Issues opened in GitHub create a bug in Azure DevOps;
- All pushes made in GitHub are synced to Azure DevOps (that includes all branches except `master`);
- When a GitHub Pull Request is submitted, it is analyzed and merged in `develop` on GitHub, then synced to Azure DevOps that will trigger the CI;
- A Pull Request is then submitted in Azure DevOps to merge `develop` to `master`, it runs the CI again;
- Once merged to `master`, the CI is one last time, but this time it will create a Chocolatey and a NuGet packages that are pushed on private Azure DevOps Artifacts feeds;
- If the CI succeeds and the packages are well pushed, the CD is triggered.

### CI

The CI is an Azure DevOps build pipeline that will:
- Test the module with _[Pester](https://pester.dev/)_ tests;
- Run the _[PSScriptAnalyzer](https://github.com/PowerShell/PSScriptAnalyzer)_;
- Mirror the repository to GitHub

| Branch       | Status  |
| ------------ | ------- |
| `master`     | [![Build status](https://dev.azure.com/baptistecabrera/Bca/_apis/build/status/Bca.Jwt?branchName=master)](https://dev.azure.com/baptistecabrera/Bca/_build/latest?definitionId=4?branchName=master) |
| `develop`    | [![Build status](https://dev.azure.com/baptistecabrera/Bca/_apis/build/status/Bca.Jwt?branchName=develop)](https://dev.azure.com/baptistecabrera/Bca/_build/latest?definitionId=4?branchName=develop) |

### CD

The CD is an Azure DevOps release pipeline is trigerred that will:
- In a **Prerelease** step, install both Chocolatey and Nuget packages from the private feed in a container, and run tests again. If tests are successful, the packages are promoted to `@Prerelease` view inside the private feed;
- In a **Release** step, publish the packages to _[NuGet](https://www.nuget.org/)_ and _[Chocolatey](https://chocolatey.org/)_, and publish the module to _[PowerShell Gallery](https://www.powershellgallery.com/)_, then promote the packages to to `@PRelease` view inside the private feed.