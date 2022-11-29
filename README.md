
# Introduction

The purpose of this project, is to be able to quickly deploy 2 Linux VM's on Microsoft Azure. Post VM deployment, steps are included to install Iperf and some basic Iperf commands that can be run remotely, which would give an insight into the performance and bandwidth for traffic from an On-premises environment up into Azure.
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

`az  login`

`az account set --subscription subscription_ID`

`az deployment sub create --name DEPLOYMENT_NAME -l LOCATION_FOR_DEPLOYMENT -f .\deploy.bicep --parameters .\parameters\parameters-dev.json -c`


# Modifying Code 

Majority of the code is written in Bicep. Create a local repo and be able to run it from workstation. Modules are deployed from a public *Azure Container Registry*.Edit the parameters file to the your local values and requirements.

# *deploy.bicep*
This bicep file deploys the following elements
- Resource Group with tags
- Virtual Network with subnets and with tags
- 2 Public IP addresses
- 2 Virtual Network Interfaces with Static Private IP's
- 2 Linux Ubuntu Latest OS

*Use the parameters File to edit the number or values for some of the Azure services deployed above.*

## Parameters file to be edited

This file drives your deployment, so please go through the parameters file carefully and edit them. A dry run with some of the *Generalized Items* changed to new values is highly recommended.

## NSG file to be edited

This file drives the NSG. Feel free to add more NSG Blocks and the script will ensure all your NSG's are deployed. For the sake of this project, the intention is to use this deployment in a temporary manner and then either append or remove the deployment post testing. With that reasoning in mind, a single NSG rule is present which requires your current *Public IP* from where you would be deploying this code. 

# Post Deployment Steps
1. Once the bicep file has been executed, using a tool like *putty* login to both your linux vm's that have been deployed onto Azure. Use the Public IP DNS labels to log onto them from your local machine.
2. First do an update of the vm by running the following command `sudo apt update`
3. In order to run basic commands like *ifconfig* please run the following command `sudo apt install net-tools`
4. Let's install the iperf package. For this project, the following command 
`sudo apt install -y iperf3`

# Running Iperf
Within the same terminal from above, choose one of the servers to be the Server and the other to be the client. Since both servers are running within the same Vnet, there is no difference on which one performs the server and client role.

## Server Role
The following command, starts iperf3 on that box as a server and it will show you data transfers in the format of bits, Bytes, Kbits, Mbits, Gbits, KBytes, MBytes, GBytes.
### Example:
`iperf3 -s -f K ` or `iperf3 -s -f GB`

## Client Role
The following command, starts iperf3 on that box as a client sending / recieving iperf traffic to and from the iperf server. There are a lot of combination of commands that can be leveraged here.  [Popular Iperf Commands](https://www.cyberithub.com/iperf-commands-how-to-use-iperf-in-linux/#:~:text=If%20you%20want%20to%20test%20TCP%20Connection%20using,segment%20size%20of%2065535%20bytes%20for%20TCP%20testing.)

### Example:
`iperf3 -c client_IP -i 1 -t 60 -P 16`

# Summary
Iperf is a popular tool, and it is widely used in solving Bandwidth, Slowness issues between networks. Running it from outside of Azure towards your potential Azure regions of deployment, will give you a general sense of how that experience is going to turn out. 

In production scenario's there will be more network components and elements at play which will definitely affect your outcome, however running a tool like iperf on VM's on Azure can help you mitigate many of these issues.

Good luck!

# Future Releases / Changes 
- Better VM password Management 
- Configuration of Iperf3 on the server post deployment using Configuration / Extentions script
- Virtual WAN 
- Azure Firewall 
- ASG's 
- Multi Region Deployment
- Screenshots