
# Introduction

The purpose of this project, is to be able to quickly deploy 2 Linux VM's on Microsoft Azure. Post VM deployment, steps are included to install Iperf and some basic Iperf commands that can be run remotely, which would give an insight into the performance and bandwidth for traffic from an On-premises environment up into Azure.

# Code 

The code is written in Bicep. Create a local repo and be able to run it from workstation. Ensure to edit the parameters file to the your local values and requirements. Specific lines that need to be edited are mentioned below

## Parameters file to be edited
-  Line 1
-  Line 2

# Deploying the Code

## Prerequisites
- [ ] Install Azure CLI
- [ ] Install BICEP
- [ ] Install Visual Studio Code 

## Steps to deploy the Code
1. Create a clone of this repo to your local system
2. Edit the Parameters file as per above
3. Open your favourite terminal
4. Run the following Az CLI commands

    ```
`az  login`

`az account set --subscription subscription_ID`

`az deployment sub create --name DEPLOYMENT_NAME -l LOCATION_FOR_DEPLOYMENT -f .\deploy.bicep --parameters .\parameters\parameters-dev.json -c`
   ```