#Connect-AzAccount
$OutputFinal=@()
$networkpath = "C:\test.csv"

$FWSubscription = "testvalue"
Set-AzContext -SubscriptionName $FWSubscription

$rg = "Resource Group Name of Azure Firewall"
$AllFirewalls = Get-AzFirewall -ResourceGroupName $rg

foreach ($Firewall in $AllFirewalls){

$AzureFirewallName = $Firewall.Name
$AzureFirewallAppRuleCollections = $Firewall.ApplicationRuleCollectionsText | ConvertFrom-Json

    foreach ($Collection in $AzureFirewallAppRuleCollections){
    $AzureFirewallAppRuleCollectionsName = $Collection.Name
    $AzureFirewallAppRules = $Collection.Rules

        foreach ($AppRule in $AzureFirewallAppRules){            
            $AzureFirewallAppRulesName = $AppRule.Name
            $AzureFirewallAppRulesSourceAddress = $AppRule.SourceAddresses  -join ", "
            $AzureFirewallAppRulesTargetFqdns = $AppRule.TargetFqdns        -join ", "

                foreach ($Protocol in $AppRule.Protocols){
                    $AzureFirewallAppRulesProtocolType = $Protocol.ProtocolType
                    $AzureFirewallAppRulesPort = $Protocol.Port



                                $outputtemp = [PSCustomObject]@{
                                "AZFWName" = $AzureFirewallName
                                "AZFWAppRuleCollectionsName" = $AzureFirewallAppRuleCollectionsName
                                "AzFWAppRulesName" = $AzureFirewallAppRulesName
                                "AzFWAppRulesSourceAddress" = $AzureFirewallAppRulesSourceAddress
                                "AzFWAppRulesTargetFqdns" = $AzureFirewallAppRulesTargetFqdns
                                "AzFWAppRulesProtocolType" = $AzureFirewallAppRulesProtocolType
                                "AzFWAppRulesPort" = $AzureFirewallAppRulesPort
                                                                }

                                $outputfinal += $outputtemp
                                                        }



        }

    }

}

$outputfinal | export-csv -Path $networkpath -NoTypeInformation
