# Azure Multi-Stage Web Infrastructure Deployment

This project deploys a web infrastructure in Azure in three stages: development, testing, and production. The infrastructure composed of a virtual machine, a virtual network and a storage account.

Terraform module method was used to create a web infrastructure that is deployed in three stages.

Creating Terraform modules provides an easy and efficient way to build reusable and scalable infrastructure designs. This inclusion of Terraform module structure in this project is aimed at reducing errors and enhancing continuity by managing infrastructure in a modular manner.

## Dependencies

This project requires the following dependencies:

* Terraform
* Azure CLI

## Variables

The following variables are used by this project:

* `stage`: The stage of the deployment (dev, test, or prod)
* `prefix`: A prefix for the resources created in the deployment
* `network_cidr`: The CIDR block for the virtual network
* `subnet_cidr`: The CIDR block for the subnet
* `public_ip_name`: The name of the public IP address
* `vm_size`: The size of the virtual machine
* `storage_account_name`: The name of the Azure Storage account
* `location`: The name of the Azure region where these resources will be created

## Expected Outcome

The following resources are created by this project:

* A resource group
* A virtual network
* A subnet
* A network security group
* A network interface
* A public IP address
* A virtual machine
* An OsDisk (Managed Disk)
* A storage account
* A storage container


## Project Skeleton

* A module is a container for multiple resources that are used together.

* The .tf files in the working directory when you run terraform plan or terraform apply together form the root module. That module may call other modules and connect them together by passing output values from one to input values of another.

The directory structure of this project is as follows:


```

├── Modules
│   ├── main.tf
│   ├── output.tf
│   ├── terraform.tfstate
│   ├── terraform.tfstate.backup
│   └── variable.tf
├── dev
│   ├── dev.tf
│   ├── terraform.tfstate
│   └── terraform.tfstate.backup
├── product
│   ├── product.tf
│   ├── terraform.tfstate
│   └── terraform.tfstate.backup
└── test
├── terraform.tfstate
├── terraform.tfstate.backup
└── test.tf

```

The `Modules` directory contains the Terraform configuration for the common resources, such as the resource group such as these: virtual machine, a virtual network and a storage account. The `dev`, `product`, and `test` directories contain the Terraform configuration for the specific resources for each stage. The `main.tf` file in each directory is the main entry point for the Terraform configuration. The `output.tf` file in each directory defines the output variables for the Terraform configuration. The `terraform.tfstate` and `terraform.tfstate.backup` files in each directory store the state of the Terraform configuration. The `variable.tf` file in the `Modules` directory defines the variables that are used by the Terraform configuration.



## Steps to Solution

* Step 1: Download or clone project definition from `https://github.com/hiamsule/AzureProjekt` repo on Github.
* Step 2: Create project folder for local public repo on your pc.
* Step 3: Access the path to the Modules folder using [VS Code, Git Bash, IntelliJ IDEA or another shell].

* Go to the Modules/main.tf file, execute the following commands.

```
terraform init

terraform fmt

terraform validate

terraform plan

```

* Step 4: To deploy the infrastructure in the deployment stage, run the following command.
** Make sure you get to the path of the dev folder before executing the commands.

```

terraform init

terraform fmt

terraform validate

terraform plan

terraform apply --auto-approve

```

* Step 5: To deploy the infrastructure in the testing stage, run the following command
** Make sure you get to the path of the test folder before executing the commands

```

terraform init

terraform fmt

terraform validate

terraform plan

terraform apply --auto-approve

```

* Step 6: To deploy the infrastructure in the production stage, run the following command
** Make sure you get to the path of the product folder before executing the commands

```

terraform init

terraform fmt

terraform validate

terraform plan

terraform apply --auto-approve

```
## Status Check

This can be checked in a number of ways to make sure that the resources are being created correctly.

```
- Check the terraform.tfstate

- Check by making the necessary filtering from the source group from the Azure console

- enter "terraform state list" command

```

To check if ngin is installed inside the virtual machine, choose one of these steps:
(For this, you can choose one of three alternative solutions.)

```
1. ssh connection to the virtual machine with public ip
   Go to /etc/nginx/ path and check if ngin is installed

2.The Public Ip of the virtual machine in the browser and search for it

3.Establish a remote ssh connection, and check your nginx config settings (be sure to configure the ssh host configuration first)

```

## Destroy

The terraform destroy command terminates resources defined in your Terraform configuration. This command is the reverse of terraform apply in that it terminates all the resources specified by the configuration. It does not destroy resources running elsewhere that are not described in the current configuration.

* Go to the dev test and product folders and run the command below.
```

terraform destroy --auto-approve

```

## Resources

* [Terraform Azure Provider Documentaion](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs)
* [Azure CLI Command Reference](https://learn.microsoft.com/en-us/cli/azure/)
* [Cloud init for custom data](https://learn.microsoft.com/en-us/azure/virtual-machines/linux/tutorial-automate-vm-deployment)
* [Creating Microsoft Azure Virtual Machines for NGINX](https://docs.nginx.com/nginx/deployment-guides/microsoft-azure/virtual-machines-for-nginx/)

## License

* This project is licensed under the MIT License.
