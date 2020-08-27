# Add-URLtoUmbrella
- Use PowerShell to add a given hyperlink to Cisco Umbrella using Enforcement API
- Umbrella Enforcement API Documentation: https://docs.umbrella.com/enforcement-api/reference/ 

## To use this script
- Line 13: API key
  - Follow instructions on Cisco Umbrella account to create an API key
- Line 21: URL you want to add to your Umbrella enforcement list (if you aren't using CLI entry)

## To use from CLI: 
- -u: URL
- Examples
```
.\Add-URLtoUmbrella.ps1 -u https://notverybelievable.com
```

## Operations
- Enter any type of domain, with or without paths
  - The script manipulates the input to isolate the domain from input
  - The script generates a URL from input by adding "http://" before the domain if protocol is not specified
  - This is because both domain and URL are required by API for submission
- script checks against its own allow list which you can maintain: (https://github.com/cbshearer/Add-URLtoUmbrella/blob/master/whitelist.txt)  
- Umbrella 'Domain Acceptance Process' already sorts the domains and compares against the Alexa top 1000  

## Output
- Domain: the domain of your input
- URL: the URL of your input (may be a composite made by prepending "http://"
- Allow list: Was this domain found on your allow list
- Result: The domain is displayed and whether or not it was added to Cisco Umbrella successfully.
