# Add-URLtoUmbrella
- Use PowerShell to add a given hyperlink to Cisco Umbrella using Enforcement API
- Umbrella [Enforcement API Documentation](https://docs.umbrella.com/enforcement-api/reference/)

## To use this module
- Import the module

```PowerShell
PS C:\temp> Import-Module .\Add-URLtoUmbrella.psm1
```

- If you want to install the module for long-term use
  - See [Microsoft documentation](https://docs.microsoft.com/en-us/powershell/scripting/developer/module/installing-a-powershell-module?view=powershell-7).
  - Shortcut - just copy to its own folder in this location: $Env:ProgramFiles\WindowsPowerShell\Modules

```PowerShell
PS C:\temp> copy .\Add-URLtoUmbrella.psm1 $Env:ProgramFiles\WindowsPowerShell\Modules\Add-URLtoUmbrella\Add-URLtoUmbrella.psm1
```

- Line 17: API key
  - Follow instructions from [Cisco Umbrella](https://support.umbrella.com/hc/en-us/articles/231248748-Cisco-Umbrella-The-Umbrella-Enforcement-API-for-Custom-Integrations) account to create an API key.

## To use from CLI: 
- -u: URL
- Examples

```PowerShell
Add-URLtoUmbrella -u https://notverybelievable.com
Add-URLtoUmbrella -u https://www.scaryurl-for-badguys.org/malware/html/index.php,phishingexample.top
```

## Operations
- Enter any type of domain, with or without paths
  - The script manipulates the input to isolate the domain from input.
  - The script generates a URL from input by adding "http://" before the domain if protocol is not specified.
  - This is because both domain and URL are required by API for submission.
- Script checks to see if the URL submitted is in the allow list you maintain: (https://github.com/cbshearer/Add-URLtoUmbrella/blob/master/AllowList.txt)  
- Umbrella [Domain Acceptance Process](https://docs.umbrella.com/enforcement-api/reference#domain-acceptance-process-1) already sorts the domains and compares against the Alexa top 1000  

## Output
- Domain: the domain of your input
- URL: the URL of your input (may be a composite made by prepending "http://"
- Allowed?: Was this domain found on your allow list
- Result: The domain is displayed and whether or not it was added to Cisco Umbrella successfully.
