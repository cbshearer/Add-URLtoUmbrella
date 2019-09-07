## Cisco Umbrella Enforcement
## Chris Shearer
## 8.30.2019
## Umbrella Enforcement API: https://docs.umbrella.com/enforcement-api/reference/

## Specify TLS
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls -bor [Net.SecurityProtocolType]::Tls11 -bor [Net.SecurityProtocolType]::Tls12 

## Umbrella key
    $UmbrellaCustomerKey    = "1111-2222-3333-4444"
    $UmbrellaURI            = "https://s-platform.api.opendns.com/1.0/events?customerKey=" + $UmbrellaCustomerKey

## Domain to add    
    $MalURL = "https://www.internetbadguys.com/bad/url.php"

## Clean up URL
    ## add http:// if it isn't there
        if  ($malurl -notlike "http*") {$malurl = "http://" + $malurl}
    ## Reduce full URL to just the domain
        $Domain = ([System.Uri]$malURL).Host -replace '^www\.'
        write-host "Domain : " $Domain
        if (!($domain)) {$domain = $malurl}

## Specify header
    $UmbrellaHeaders = @{'Content-Type' = 'application/json'}

## Compose date to specification
    $UmbrellaDate = get-date -f yyyy-MM-ddThh:mm:ssZ
    
## Build body 
    $UmbrellaBody =  [pscustomobject]@{"alertTime"=$UmbrellaDate;
                                        "deviceId"=$env:computername;
                                        "deviceVersion"="TAP via Powershell 1.0";
                                        "dstDomain"=$domain;
                                        "dstUrl"=$MalURL;
                                        "eventTime"=$UmbrellaDate;
                                        "protocolVersion"="1.0a";
                                        "providerName"="Security Platform";
                                        }
        
## Convert body to JSON
    $UmbrellaBody = $UmbrellaBody | ConvertTo-Json

## Add this domain/url to Umbrella            
    try { 
        ## make the call
            $UmbrellaAdd = Invoke-RestMethod -uri $UmbrellaURI -ErrorVariable RestError -Headers $UmbrellaHeaders -body $UmbrellaBody -Method Post
        }
    catch {
            $cat = $_                      ## If there is an error store it as $cat
            write-host -f cyan $cat
            write-host -f blue $RestError
        }
## Resulting data stored here
    if ($UmbrellaAdd.id) {write-host -f Green "Success: " $umbrellaAdd.id}
