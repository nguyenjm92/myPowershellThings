#$ResourceGroupName = Read-Host "Please provide name of ResourgeGroup that will be used for saving the NSG logs"
$StorageAccountLogs = Read-Host "Storage account ID"
$retentionperiod = Read-Host "Retention period number"

#Login to the Azure Resource Management Account
#Login-AzAccount
Register-AzResourceProvider -ProviderNamespace Microsoft.Insights
# Microsoft Insights provider needs to be registered in order to log flow
# Need proper permissions on the subscription


#$subscriptions = Get-AzSubscription
$subscription = @('sub')
$subscription | Get-AzSubscription -SubscriptionName {$subscription} | Set-AzContext

$subscriptionID = (Get-AzContext).Subscription.Id
$subscriptionName = (Get-AzContext).Subscription.Name


#This should be grabbing the Network Watcher regions
#$storageAccount = Get-AzStorageAccount -ResourceGroupName $ResourceGroupName -Name $StorageAccountLogs
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
            
            }

        }

}
