Param (
      [Parameter(Mandatory = $true)]
      [string] $resourcegroupName,

      [Parameter(Mandatory = $true)]
      [string] $sqlserverName,

      [Parameter(Mandatory = $true)]
      [string] $lawResourceId,

      [Parameter(Mandatory = $true)]
      [string] $eventhubName,

      [Parameter(Mandatory = $true)]
      [string] $eventhubAuthorizationRuleResourceId,

      [Parameter(Mandatory = $true)]
      [string] $storageAccountResourceId
)

if ($null -ne $resourcegroupName -and $null -ne $sqlserverName)
{
      # Add Log Analytics Workspace to Auditing 
      if ($null -ne $lawResourceId ) {
            Write-Host "You Are willing to create Audit Logs for server on Log Analytics Workspace ...... "
            ServerAuditStorageAccount $resourcegroupName $sqlserverName $lawResourceId
            MSSupportAuditStorageAccount $resourcegroupName $sqlserverName $lawResourceId
      }
      # Add Event Hub to Auditing
      if( ($null -ne $eventhubName) -and ($null -eq $eventhubAuthorizationRuleResourceId) ) {
            Write-Host "You Are willing to create Audit Logs for server on Event Hub ...... "
            ServerAuditEventHub $resourcegroupName $sqlserverName $eventhubName $eventhubAuthorizationRuleResourceId
            MSSupportAuditEventHub $resourcegroupName $sqlserverName $eventhubName $eventhubAuthorizationRuleResourceId
      }
      # Add Storage Account to Auditing
      if( $null -ne $storageAccountResourceId ) {
            Write-Host "You Are willing to create Audit Logs for server on Storage Account ...... "
            ServerAuditWorkspace $resourcegroupName $sqlserverName $storageAccountResourceId
            MSSupportAuditWorkspace $resourcegroupName $sqlserverName $storageAccountResourceId
      }
      
      else {
            Write-Host "You had provided the Workspace, Storage Account and Event Hub Details as empty Values...... "
      }
}
else {
      Write-Host "You had provided the Resource Group and Sql Server Names as empty Values...... "
}

function ServerAuditStorageAccount {
      param(
            [Parameter(Mandatory = $true)]
            [string] $resourcegroupName,

            [Parameter(Mandatory = $true)]
            [string] $sqlserverName,

            [Parameter(Mandatory = $true)]
            [string] $storageAccountResourceId
      )

      $ServerAuditserviceExists = Get-AzSqlServerAudit -ResourceGroupName $resourcegroupName -ServerName $sqlserverName

      if( $null -ne $ServerAuditserviceExists.StorageAccountResourceId ) {
            Write-Host "Storage Account is configured for Server Auditing at Server Level"
      }
      else {
            Write-Host "Enabling SQL Server Auditing at Server Level for Storage Account"                  
            Set-AzSqlServerAudit -ResourceGroupName $resourcegroupName -ServerName $sqlserverName -BlobStorageTargetState Enabled -StorageAccountResourceId $storageAccountResourceId
      }
}

function ServerAuditEventHub {
      param( 
            [Parameter(Mandatory = $true)]
            [string] $resourcegroupName,

            [Parameter(Mandatory = $true)]
            [string] $sqlserverName,

            [Parameter(Mandatory = $true)]
            [string] $eventhubName,

            [Parameter(Mandatory = $true)]
            [string] $eventhubAuthorizationRuleResourceId
      )

      $ServerAuditserviceExists = Get-AzSqlServerAudit -ResourceGroupName $resourcegroupName -ServerName $sqlserverName

      if( $null -ne $ServerAuditserviceExists.EventHubName -and  $null -ne $ServerAuditserviceExists.EventHubAuthorizationRuleResourceId ) {
            Write-Host "Event Hub is configured for Server Auditing at Server Level"
      }
      else{
      
            Write-Host "Enabling SQL Server Auditing at Server Level for Event Hub"
            Set-AzSqlServerAudit -ResourceGroupName $resourcegroupName -ServerName $sqlserverName -EventHubTargetState Enabled -EventHubName $eventhubName -EventHubAuthorizationRuleResourceId $eventhubAuthorizationRuleResourceId      
      }
}

function ServerAuditWorkspace {     
      param (
            [Parameter(Mandatory = $true)]
            [string] $resourcegroupName,

            [Parameter(Mandatory = $true)]
            [string] $sqlserverName,

            [Parameter(Mandatory = $true)]
            [string] $lawResourceId
      ) 

      $ServerAuditserviceExists = Get-AzSqlServerAudit -ResourceGroupName $resourcegroupName -ServerName $sqlserverName

      if( $null -ne $ServerAuditserviceExists.WorkspaceResourceId) {
            Write-Host "Log Analytics Workspace is configured for Server Auditing at Server Level"
      }
      else {
            Write-Host "Enabling SQL Server Auditing at Server Level for Log Analytics Workspace "
            Set-AzSqlServerAudit -ResourceGroupName $resourcegroupName -ServerName $sqlserverName -WorkspaceResourceId $lawResourceId -LogAnalyticsTargetState Enabled
      }
}

function MSSupportAuditStorageAccount {
      param(
            [Parameter(Mandatory = $true)]
            [string] $resourcegroupName,

            [Parameter(Mandatory = $true)]
            [string] $sqlserverName,

            [Parameter(Mandatory = $true)]
            [string] $storageAccountResourceId
      )

      $MSSupportAuditserviceExists = Get-AzSqlServerMSSupportAudit -ResourceGroupName $resourcegroupName -ServerName $sqlserverName
      
      if( $null -ne $MSSupportAuditserviceExists.StorageAccountResourceId ) {
            Write-Host "Storage Account is configured for Microsoft Auditing at Server Level"
      }
      else {
            Write-Host "Enabling Microsoft Support Operations Auditing at Server Level for Storage Account"
            Set-AzSqlServerMSSupportAudit -ResourceGroupName $resourcegroupName -ServerName $sqlserverName -BlobStorageTargetState Enabled -StorageAccountResourceId $storageAccountResourceId     
      }
}

function MSSupportAuditEventHub {
      param( 
            [Parameter(Mandatory = $true)]
            [string] $resourcegroupName,

            [Parameter(Mandatory = $true)]
            [string] $sqlserverName,

            [Parameter(Mandatory = $true)]
            [string] $eventhubName,

            [Parameter(Mandatory = $true)]
            [string] $eventhubAuthorizationRuleResourceId
      )
      $MSSupportAuditserviceExists = Get-AzSqlServerMSSupportAudit -ResourceGroupName $resourcegroupName -ServerName $sqlserverName

      if( $null -ne $MSSupportAuditserviceExists.EventHubName -and $null -ne $MSSupportAuditserviceExists.EventHubAuthorizationRuleResourceId) {
            Write-Host "Event Hub is configured for Microsoft Auditing at Server Level"
      }
      else {
            Write-Host "Enabling Microsoft Support Operations Auditing at Server Level for Event Hub"
            Set-AzSqlServerMSSupportAudit -ResourceGroupName $resourcegroupName -ServerName $sqlserverName -EventHubTargetState Enabled -EventHubName $eventhubName -EventHubAuthorizationRuleResourceId $eventhubAuthorizationRuleResourceId         
      }
}

function MSSupportAuditWorkspace { 
      param (
            [Parameter(Mandatory = $true)]
            [string] $resourcegroupName,

            [Parameter(Mandatory = $true)]
            [string] $sqlserverName,

            [Parameter(Mandatory = $true)]
            [string] $lawResourceId
      ) 
      $MSSupportAuditserviceExists = Get-AzSqlServerMSSupportAudit -ResourceGroupName $resourcegroupName -ServerName $sqlserverName

      if( $null -ne $MSSupportAuditserviceExists.WorkspaceResourceId ) {
            Write-Host "Log Analytics Workspace is configured for Microsoft Auditing at Server Level"
      }
      else {
            Write-Host "Enabling Microsoft Support Operations Auditing at Server Level for Log Analytics Workspace"
            Set-AzSqlServerMSSupportAudit -ResourceGroupName $resourcegroupName -ServerName $sqlserverName -WorkspaceResourceId $lawResourceId -LogAnalyticsTargetState Enabled
      }
}





