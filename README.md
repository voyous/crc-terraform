# Cloud Resume Challenge — Infrastructure

Infrastructure as Code for my Cloud Resume Challenge, built using Terraform and Azure.

## Current infrastructure

- Azure resource group (`crc-resume-website`) in Australia East
- Azure Storage Account (`crcwebsitesa01`) using Standard/LRS
- Private `$web` storage container
- Azure Storage static website hosting
- Live website: [resume.voyous.dev](https://resume.voyous.dev)

## Planned infrastructure

- Manage DNS for [resume.voyous.dev](https://resume.voyous.dev) with Cloudflare and Terraform
- Cloudflare CDN and security configuration
- Azure Functions
- Azure Cosmos DB
- Terraform remote state

## Prerequisites

- [Terraform](https://developer.hashicorp.com/terraform/install)
- An Azure subscription
- [Azure CLI](https://learn.microsoft.com/cli/azure/install-azure-cli) authenticated to that subscription

## Usage

1. Sign in to Azure and select the subscription to use:

   ```sh
   az login
   az account set --subscription "<subscription-id>"
   ```

2. Review `main.tf`. Resource names, location, and the custom domain are currently hard-coded; change them as needed before applying. Azure Storage Account names must be globally unique.

3. Initialize Terraform and review the proposed changes:

   ```sh
   terraform init
   terraform plan
   ```

4. Apply the configuration:

   ```sh
   terraform apply
   ```

5. To remove the resources managed by this configuration:

   ```sh
   terraform destroy
   ```

Terraform state is stored locally at the moment. State files are excluded by `.gitignore`
