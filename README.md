# Cloud Resume Challenge — Infrastructure

Infrastructure as Code for my Cloud Resume Challenge, built using Terraform and Azure.

## Current infrastructure

- Azure resource groups for front-end and back-end
- Azure Storage Accounts using Standard/LRS
- Manage DNS for custom domain with Cloudflare and Terraform
- Cloudflare CDN
- Private `$web` storage container
- Azure Function App
- Azure Cosmos DB
- Live website: [resume.voyous.dev](https://resume.voyous.dev)

## Planned infrastructure
- Cloudflare security configuration
- Custom domain mapping to the Function App
- Random name generation for resources
- Terraform remote state

## Prerequisites

- [Terraform](https://developer.hashicorp.com/terraform/install)
- An Azure subscription
- [Azure CLI](https://learn.microsoft.com/cli/azure/install-azure-cli) authenticated to that subscription
- Cloudflare account and API token

## Usage

1. Sign in to Azure and select the subscription to use:

   ```sh
   az login
   ```

2. Create terraform.tfvars using terraform.tfvars.example and update values. Azure Storage Account names must be globally unique.

3. Add Cloudflare API token:

   ```sh
   export CLOUDFLARE_API_TOKEN="<Your Cloudflare API Token>"
   ```

4. Initialize Terraform and review the proposed changes:

   ```sh
   terraform init
   terraform plan
   ```

5. Apply the configuration:

   ```sh
   terraform apply
   ```

6. To remove the resources managed by this configuration:

   ```sh
   terraform destroy
   ```

Terraform state is currently stored locally. State files are excluded by `.gitignore`
