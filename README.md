## Setting up API Management Service with Virtual Network and App Service Plan using Terraform
Overview:
This document provides step-by-step instructions I deployed an API Management service with a virtual network, subnets, and an App Service plan for the "Staging" and "Production" environments in Azure using Terraform.
### Prerequisites:
    •	Azure account with Subscription
    •	Service Principal for authentication
    •	Terraform installed and configured with Azure credentials.
    •	Vscode for Text editor. 
### Steps:
1.	**Create Service principal on azure active directory**: Service principal is the recommended way to authenticate applications such as terraform to azure. The service principal is created when an application is registered on azure AD through azure app registration. It is basically an identity of your application represented in azure AD which has the right role and permission to interact with azure resource.

The command below was used to create a service principal for terraform with a contributor role. The command is run on azure cloudshell using the bash option
<br>``az ad sp create-for-rbac --name terraform --role Contributor --scopes /subscriptions/<my_subscription_id>`` 

The output from the above command looks like the screenshot shown below. Copied it and saved it in a note pad. I used it in terraform code for authentication. 
 ![image](https://github.com/ifyokeibunor/Eurowinfrastructure/assets/104580680/32fa9331-4d32-4af8-9806-5bba5e8fc904)


As best practice, I created a separate file called terraform.tfvars file where the above output is used as environmental variable. This way, secrets will not be hardcoded in the terraform configuration file
 ![image](https://github.com/ifyokeibunor/Eurowinfrastructure/assets/104580680/8fb61bf6-c27e-44d3-96f1-62ca5e822b7c)

### IMPORTANT: 
•	Best practice for network configuration; the subnet should have at least a /24 network address space. This allows for proper scaling of App service plan
Network: /24 gives 256 IP addresses for the subnets this provides room for scaling of app service plan. Azure reserves 5 addresses from this pool for azure services. This leaves us with 251 usable host addresses in each subnet
Vnet: 172.16.0.0/16
Staging Subnet: 172.16.0.0/24  
Production Subnet: 172.16.1.0/24
•	Based and environment and requirement, a Network security group was created allow communication on port 443 and 80. (this can be relative to different environments). I created the network security group **_eurow_am_sg_** and associated it to the relevant subnet
![image](https://github.com/ifyokeibunor/Eurowinfrastructure/assets/104580680/bf512802-dd79-492d-9c4d-e3985d871ba7)

2.	**Create a new Terraform file:**
Create a directory for terraform files, name its “Infrastructure”. In this directory, create 3 files, varaiable.tf, terraform.tfvars (to pass the variables) and the configuration file named eurowinfra.tf (or any descriptivename.tf). all files available on github repository.

3.	**Save the eurowinfra.tf file**.
4.	Open a terminal or command prompt and navigate to the directory where the main.tf file is saved.
5.	**Initialize Terraform**:
•	Run the command terraform init to initialize the Terraform configuration.
6.	**Plan and deploy the infrastructure:**
•	Run the command terraform plan to see the deployment plan
•	Run the command terraform apply. This command provisions the resources defined in the terraform file into Azure.
•	Review the changes proposed by Terraform and type "yes" to confirm the deployment.
7.	Wait for the deployment to complete.
•	Terraform will create the, virtual network, subnets, App Service plans and API Management service in Azure according to the specified configuration.
8.	Access and manage the deployed resources:
•	access the Azure portal to view and manage the deployed resources, including the API Management service, virtual network, subnets, and App Service plans.
•	Use the Azure portal, Azure CLI, or Azure PowerShell to interact with and configure the resources further, as required. Such as Network security group.
