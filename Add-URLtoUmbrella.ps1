## Umbrella Enforcement API: https://docs.umbrella.com/enforcement-api/reference/

## specify TLS1.2
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls -bor [Net.SecurityProtocolType]::Tls11 -bor [Net.SecurityProtocolType]::Tls12 

## PP TAP PS key
$UmbrellaCustomerKey    = "1111-2222-3333-4444"
$UmbrellaURI            = "https://s-platform.api.opendns.com/1.0/events?customerKey=" + $UmbrellaCustomerKey
write-host "$UmbrellaURI" -f Green

    ## Specify headers
        $UmbrellaHeaders = @{'Content-Type' = 'application/json'}

    ## build date to specification
        $UmbrellaDate = get-date -f yyyy-mm-ddThh:mm:ssZ
    
    ## build body 
        $UmbrellaBody = @("`{`"alertTime`":`"$UmbrellaDate`";`"deviceID`":`"WXYZ`";`"deviceVersion`":`"TAP via Powershell 1.0`";`"dstDomain`":`"internetbadguys.com`";`"dstURL`":`"https://internetbadguys.com/bad/file/path`";`"eventTime`":`"$UmbrellaDate`";`"protocolVersion`":`"1.0a`";`"providerName`":`"Security Platform`"`}")
        
    ## convert body to JSON?
        $UmbrellaBody = $UmbrellaBody | ConvertTo-Json

    ## Add this domain/url to Umbrella            
        try { 
            ## make the call
                $UmbrellaAdd = Invoke-RestMethod -uri $UmbrellaURI -ErrorVariable RestError -Headers $UmbrellaHeaders -body $UmbrellaBody -Method Post
            }
        catch {
                $catch = $_.Exception ## if there is an error store it as catch
                write-host -f cyan $catch
                write-host -f blue $RestError
            }
    ## resulting data stored here
        $UmbrellaAdd
