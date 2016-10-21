# Recommended VM deployment for Qlik Sense on Azure 
WARNING - This is a sample template and documentation that has not yet been aproved by Qlik. Please use at your own risk!!!

<a href="https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fgithub.com%2Fgoldbergjeffrey%2Fqlik%2Fblob%2Fmaster%2FQlikSense%2FQlikSenseAzure%2FTemplates%2Fazuredeploy.json" target="_blank">
    <img src="http://azuredeploy.net/deploybutton.png"/>
</a>
<a href="http://armviz.io/#/?load=https%3A%2F%2Fgithub.com%2Fgoldbergjeffrey%2Fqlik%2Fblob%2Fmaster%2FQlikSense%2FQlikSenseAzure%2FTemplates%2Fazuredeploy.json" target="_blank">
    <img src="http://armviz.io/visualizebutton.png"/>
</a>


This template deploys a Virtual Machine with recommended settings for running Qlik Sense on Microsoft Azure. The actual template and a sample parameter file can be found [here](QlikSense/QlikSenseAzure/Templates)

## Deploy using portal

Deploy this template to Azure by clicking on the "Deploy to Azure" button above or get a visual representation of it by clicking the "Visualize" button. You could also copy the template (see link above to the template in this repository) and paste it directly in the [Azure Portal](https://portal.azure.com) when you select to create a new "Templated Deployment".


## Azure CLI

Deploy using [Azure CLI](https://azure.microsoft.com/en-us/documentation/articles/xplat-cli-install/) (Cross platform tools) by executing the following commands.

~~~~
azure group create myresourcegroup --location westeurope

azure group deployment create --template-uri https://github.com/goldbergjeffrey/qlik/blob/master/QlikSense/QlikSenseAzure/Templates/azuredeploy.json myresourcegroup
~~~~

## PowerShell

Deploy using [PowerShell]() by executing the following commands.

~~~~
New-AzureRmResourceGroup -Name myresourcegroup -Location westeurope

New-AzureRmResourceGroupDeployment -ResourceGroupName myresourcegroup -TemplateUri https://github.com/goldbergjeffrey/qlik/blob/master/QlikSense/QlikSenseAzure/Templates/azuredeploy.json
~~~~

### Note on console deployments

In all of the above examples, don't execute the first command if you plan on deploying to an allready existing Resource Group in your Azure Subscription.

Replace:

* westeurope - with the location you prefer to deploy to
* myresourcegroup - with a name of a resource group you want to create and/or deploy to

## How to continue?

This templated deployment will only deploy the infrastructure/Virtual Machine that you need in order to fullfill a complete Qlik Sense setup. Please follow the rest of the documentation from Qlik in order to fullfill the setup of Qlik Sense on your VM.
