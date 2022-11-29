targetScope = 'subscription'

// ----------------------------------------
// Parameter declaration
@description('Application components these resources are part of.')
param component string

@description('Name of the Deployment Engineer')
param createdby string

@description('Environment for deployment')
param env string

@description('Application product these resource are assigned too')
param product string
@description('Current Date for deployment records. Do not overwrite!')
param currentDate string = utcNow('yyyy-MM-dd')

@description('Azure region for deployment.')
param location string = deployment().location

@description('A list of required and optional subnet propeties.')
param subnets array

@description('Virtual Network Address Range')
param addressPrefixes array

@description('Dictionary of deployment regions and the shortname')
param locationList object

@description('Custom DNS servers for Virtual Network')
param dnsServers array

@description('NSG Rules to be loaded')
param nsgSecurityRules array = json(loadTextContent('..../../parameters/nsg-rules.json')).securityRules

@description('Subscription ID for this deployment')
param environmentsubid string

@description('Name of the Subnet')
param subname string

@description('Interfaces')
param interfaces array

@description('Interfaces')
param linvms array

@description('Public Ips')
param pips array

// ----------------------------------------
// Variable declaration
var groupName                         = '${product}-${component}'
var environmentName                   = '${groupName}-${env}-${locationShortName}'
var resourceGroupName                 = 'rg-${environmentName}'
var locationShortName                 = locationList[location]
var vnetdeployname                    = 'vnetdeploy-${product}${component}-${env}-${locationShortName}'
var networkinterfacedeploymentname    = 'netintdeploy-${product}${component}-${env}-${locationShortName}'
var vmdeploymentname                  = 'vmdeploy-${product}${component}-${env}-${locationShortName}'
var pipdeploymentname                 = 'pipdeploy-${product}${component}-${env}-${locationShortName}'
var tagValues                         = {
                                          createdBy: createdby
                                          environment: env
                                          deploymentDate: currentDate
                                          product: product
                                        }


// ----------------------------------------
// Resource Group 
module platformrg 'br:acrxiu7q3336wuge.azurecr.io/bicep/publicmodules/prg:v1.22.11.1' = {
  name: resourceGroupName
  params: {
    location: location
    resourceGroupName: resourceGroupName
    tagValues: tagValues
  }
}

module virtualNetwork 'br:acrxiu7q3336wuge.azurecr.io/bicep/publicmodules/pvnet:v1.22.11.1' = {
  scope: resourceGroup(platformrg.name)
  name: vnetdeployname
  params: {
    addressPrefixes: addressPrefixes
    env: env
    location: location 
    tagValues: tagValues
    locationShortName: locationShortName
    dnsServers: dnsServers
    groupName: groupName
    subnets: subnets
    nsgSecurityRules:nsgSecurityRules
  }
}

module pip 'br:acrxiu7q3336wuge.azurecr.io/bicep/publicmodules/ppip:v1.22.11.1' = {
  scope: resourceGroup(platformrg.name)
  name: pipdeploymentname
  dependsOn: [
    virtualNetwork
  ]
  params: {
    env: env
    groupName: groupName
    location: location
    locationShortName: locationShortName
    pips: pips
    tagValues:tagValues
  }
}

module networkInterface 'br:acrxiu7q3336wuge.azurecr.io/bicep/publicmodules/pvint:v1.22.11.1' = {
  scope: resourceGroup(platformrg.name)
  name: networkinterfacedeploymentname
  dependsOn: [
    virtualNetwork
    pip   
  ]
  params: {
    env: env
    environmentsubid: environmentsubid
    groupName: groupName
    interfaces: interfaces
    location: location
    locationShortName: locationShortName
    resourceGroupName: resourceGroupName
    subname: subname
    tagValues: tagValues
  }
}

module linvm 'br:acrxiu7q3336wuge.azurecr.io/bicep/publicmodules/plinvm:v1.22.11.1' = {
  scope: resourceGroup(platformrg.name)
  name: vmdeploymentname
  dependsOn: [
    networkInterface
  ]
  params: {
    env: env
    groupName: groupName
    linvms: linvms
    location: location
    locationShortName: locationShortName
    tagValues: tagValues
  }
}



