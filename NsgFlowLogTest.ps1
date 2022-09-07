#Notes
#gzekentiklt1sto001 - Kentik storage account
#Resource ID: /subscriptions/f702ccd9-3b69-4c2f-ac45-057d53de6f08/resourceGroups/gze-kentik-lt1-rgp-001/providers/Microsoft.Storage/storageAccounts/gzekentiklt1sto001
#gze-kentik-lt1-rgp-001
##GZ-NP-SHRAPP-91-MEM: f702ccd9-3b69-4c2f-ac45-057d53de6f08

#variables
#$ResourceGroupName = Read-Host "Please provide name of ResourgeGroup that will be used for saving the NSG logs"
$KentikStorageAccountLogs = Read-Host "Storage account ID"
$retentionperiod = Read-Host "Retention period number (probably 180 days)"

#Login to the Azure Resource Management Account
#Login-AzAccount
Register-AzResourceProvider -ProviderNamespace Microsoft.Insights
# Microsoft Insights provider needs to be registered in order to log flow
# Need proper permissions on the subscription


#$subscriptions = Get-AzSubscription
$subscription = @('GZ-LT-SHRAPP-99-CNSS')
$subscription | Get-AzSubscription -SubscriptionName {$subscription} | Set-AzContext

$subscriptionID = (Get-AzContext).Subscription.Id
$subscriptionName = (Get-AzContext).Subscription.Name


#This should be grabbing the Network Watcher regions
#$storageAccount = Get-AzStorageAccount -ResourceGroupName $ResourceGroupName -Name $KentikStorageAccountLogs
$NetworkWatchers = Get-AzNetworkWatcher -ResourceGroupName NetworkWatcherRG

foreach ($NW in $NetworkWatchers){

    $NWLocation = $NW.Location
        if ($NWLocation -eq "eastus"){
        
        #$NWLocation = $NW.Location
        Write-Host "Checking $NWLocation" -ForegroundColor Yellow

        $NSGs = Get-AzNetworkSecurityGroup | Where-Object {$_.Location -eq $NWlocation}

            foreach($NSG in $NSGs){
            Get-AzNetworkWatcherFlowLogStatus -NetworkWatcher $NW -TargetResourceId $NSG.id
            $temp = Set-AzNetworkWatcherConfigFlowLog -NetworkWatcher $NW -TargetResourceId $NSG.Id -EnableFlowLog $true -StorageAccountId $KentikStorageAccountLogs -EnableRetention $true -RetentionInDays $retentionperiod -FormatVersion 2
            $temp
            Write-Host "Diagnostics enabled for $($NSG.Name)"
            
           
            #$array += $NSG.Name
            
            }

        }

}