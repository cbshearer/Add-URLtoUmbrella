## Umbrella Enforcement API: https://docs.umbrella.com/enforcement-api/reference/

## specify TLS
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls -bor [Net.SecurityProtocolType]::Tls11 -bor [Net.SecurityProtocolType]::Tls12 

## Umbrella key
    $UmbrellaCustomerKey    = "1111-2222-3333-4444"
    $UmbrellaURI            = "https://s-platform.api.opendns.com/1.0/events?customerKey=" + $UmbrellaCustomerKey

## Domains to add    
    $Domain = "internetbadguys.com"
    $MalURL = "https://www.internetbadguys.com/bad/url.php"

## Specify headers
    $UmbrellaHeaders = @{'Content-Type' = 'application/json'}

## build date to specification
    $UmbrellaDate = get-date -f yyyy-MM-ddThh:mm:ssZ
    
## build body 
    $UmbrellaBody =  [pscustomobject]@{"alertTime"=$UmbrellaDate;
                                        "deviceId"=$env:computername;
                                        "deviceVersion"="TAP via Powershell 1.0";
                                        "dstDomain"=$domain;
                                        "dstUrl"=$MalURL;
                                        "eventTime"=$UmbrellaDate;
                                        "protocolVersion"="1.0a";
                                        "providerName"="Security Platform";
                                        }
        
## convert body to JSON?
    $UmbrellaBody = $UmbrellaBody | ConvertTo-Json

## Add this domain/url to Umbrella            
    try { 
        ## make the call
            $UmbrellaAdd = Invoke-RestMethod -uri $UmbrellaURI -ErrorVariable RestError -Headers $UmbrellaHeaders -body $UmbrellaBody -Method Post
        }
    catch {
            $cat = $_.Exception ## if there is an error store it as catch
            $dog = $_
            write-host -f cyan $cat
            write-host -f blue $RestError
            write-host -f Magenta $dog
        }
## resulting data stored here
    if ($UmbrellaAdd.id) {write-host "Success: " $umbrellaAdd.id}
