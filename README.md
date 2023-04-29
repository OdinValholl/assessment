# Assessment

## Description

This repository uses Terraform to provide VMs on Azure and the regarding infrastructure covering the following resources:
* resource group including all resources
* given number of VMs
* generated passwords for VMs admins
* a virtual net in which all VMs resident
* subnet for virtual network
* network interface for connecting the VMs to the underlying virtual network and handling the network traffic
* virtual machine extensions to provide post deployment configuration and run automated tasks

## Prerequisites

* Terraform installed on your machine
* Azure subscription with valid credentials

To configure the AzureRM provider using environment variables:

````
export ARM_SUBSCRIPTION_ID=<ARM_SUBSCRIPTION_ID>
export ARM_CLIENT_ID=<ARM_CLIENT_ID>
export ARM_CLIENT_SECRET=<ARM_CLIENT_SECRET>
export ARM_TENANT_ID=<ARM_TENANT_ID>
````

## Usage

```
# Initialize Terraform
terraform init

# Plan Terraform 
terraform plan

# Plan Terraform with tfvars
terraform plan -var-file=demo.tfvars

# Apply Terraform changes
terraform apply

# Apply Terraform changes with tfvars
terraform apply -var-file=demo.tfvars

# Destroy ressources
terraform destroy
```

## Variables

| Variable             | Type   | Default        | Description                 |
|----------------------|--------|----------------|-----------------------------|
| vm_count             | number | 1              | Number of VMs to create     |
| resource_group_name  | string | resource-group | Name of the resource group  |
| location             | string | westeurope     | Azure region location       |
| virtual_network_name | string | vnet           | Name of the virtual network |
| subnet_name          | string | subnet         | Name of the subnet          |
| vm_size              | string | Standard_B2s   | Size of the VMs             |
