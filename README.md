# A recommended VM deployment for Qlik Sense on Azure 

<a href="https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Fkrist00fer%2Fqlik%2Fmaster%2FQlikSense%2FQlikSenseAzure%2FTemplates%2Fazuredeploy.json" target="_blank">
    <img src="http://azuredeploy.net/deploybutton.png"/>
</a>
<a href="http://armviz.io/#/?load=https%3A%2F%2Fraw.githubusercontent.com%2Fkrist00fer%2Fqlik%2Fmaster%2FQlikSense%2FQlikSenseAzure%2FTemplates%2Fazuredeploy.json" target="_blank">
    <img src="http://armviz.io/visualizebutton.png"/>
</a>


This template deploys a Virtual Machine with recommended settings for running Qlik Sense on Microsoft Azure. The actual template and a sample parameter file can be found [here](QlikSense/QlikSenseAzure/Templates)

## Deploy using portal

Deploy this template to Azure by clicking on the "Deploy to Azure" button above or get a visual representation of it by clicking the "Visualize" button.


## Azure CLI

Deploy using [Azure CLI](https://azure.microsoft.com/en-us/documentation/articles/xplat-cli-install/) (Cross platform tools) by executing the following commands.

~~~~
azure group create myresourcegroup --location westeurope

azure group deployment create --template-uri https://raw.githubusercontent.com/krist00fer/qlik/master/QlikSense/QlikSenseAzure/Templates/azured
eploy.json myresourcegroup
~~~~

## PowerShell

