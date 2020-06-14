## Cisco Umbrella Enforcement
## Chris Shearer
## 8.30.2019
## Umbrella Enforcement API: https://docs.umbrella.com/enforcement-api/reference/

## Accept CLI parameters
    param ($u)

## specify TLS
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12 

## Umbrella Key
    $CredFile   = import-csv 'E:\scripts\powershell\TAP\credentials.csv'
    $UmbrellaCustomerKey   = $CredFile | Where-Object -Property Type -eq 'UmbrellaCustomerKey'
    $UmbrellaCustomerKey   = $UmbrellaCustomerKey.data
    $UmbrellaURI = "https://s-platform.api.opendns.com/1.0/events?customerKey=" + $UmbrellaCustomerKey

## Assign variables if they were entered from the CLI
    if ($u){$MalURLs = @($u)}
    
## If variable wasn't passed from CLI, use what was saved into file directly, or from an external text file.
    else {
        $MalURLs  = @("https://cleverexample.buzz/go/away/now.php")}   
        #$MalURLs = Get-Content "E:\scripts\powershell\Add-toUmbrella\UMBRELLA_LIST.txt"
    }

## Reference an external customizable whitelist file rather than list multiple in this script. 
## Note the Umbrella 'Domain Acceptance Process' already sorts the domains and compares against the Alexa top 1000 (https://docs.umbrella.com/enforcement-api/reference/#domain-acceptance-process-1)
    $whitelist = get-content 'E:\scripts\powershell\add-urltoUmbrella\whitelist.txt'

## Loop through each url in the array.
foreach ($MalURL in $MalURLs)
    {
        $UmbrellaAdd = $null
        write-host -f cyan "==================="

        ## Clean up URL
            ## Add http:// if it isn't there
                if  ($MalURL -notlike "http*") {$MalURL = "http://" + $MalURL}
            ## Reduce full URL to just the domain
                $domain = ([System.Uri]$MalURL).Host -replace '^www\.'
                write-host "Domain : " $domain
                write-host "Url    : " $MalURL
                if (!($domain)) {$domain = $MalURL}
        
        ## Check whitelist before blocking
            if ($whitelist -notcontains $domain)                                
                {
                    write-host $domain -nonewline; write-host -f Green " not found in whitelist"
                    write-host $UmbrellaURI
                    ## Specify headers
                        $UmbrellaHeaders = @{'Content-Type' = 'application/json'}
                    
                    ## build date to specification
                        $UmbrellaDate = get-date -f yyyy-MM-ddThh:mm:ssZ
                    
                    ## build body 
                        $UmbrellaBody =  [pscustomobject]@{ "alertTime"=$UmbrellaDate;
                                                            "deviceId"=$env:computername;
                                                            "deviceVersion"="Add-URLtoUmbrella 1.0";
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
                            Start-Sleep 2 ## slow it down so we dont hit the rate limit of 100 calls/min.
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
                        if ($UmbrellaAdd.id) {
                            write-host -f Green "Success:" $umbrellaAdd.id
                            Write-Host -f Darkcyan $MalURL
                        }
                }
            else {Write-Host "The domain " -NoNewline; Write-Host -f green $MalURL -NoNewline; write-host " was found in the whitelist."}
    }
