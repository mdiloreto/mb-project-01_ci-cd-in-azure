# mb-project-01_ci-cd-in-azure

This repository is intended for developing a CI/CD environment in Azure using Terraform, GitHub Actions, Azure Container Registry, and Azure App Service to deliver a Continuous Integration and Continuous Delivery pipeline.

## Overview

This repository contains the Terraform configuration for deploying a scalable and secure web application on Azure. The deployment leverages several key Azure services such as Azure Container Registry (ACR), Azure Web Apps, and Azure Storage Accounts, all orchestrated to ensure smooth CI/CD integration and adherence to security best practices.

## Features

- **Web App Deployment**: Deploy web applications using Azure App Service, supporting both Linux and Windows environments.
- **Container Registry**: Manage Docker images with Azure Container Registry, integrated with webhooks for seamless image updates.
- **Storage Solutions**: Utilize Azure Blob Storage for efficient data management and access.
- **Security and Compliance**: Implement security best practices, including the use of managed identities and role-based access control.

## Prerequisites

- Azure account
- Terraform installed
- Azure CLI or PowerShell

## How to Use the Lab Scenario

1. Create the Remote State.
2. Configure Remote State data in Backend.tf.
3. Azure login:
   - `az login -t "<tenant-id>" --use-device-login`
   - `az account list`
   - `az account set -s "<subscription-id>"`
   - `az account show`
4. Perform terraform Init.
5. Set the environment variable:
   - `$env:GIT_HUB = ""`
6. Run Terraform apply.
7. Configure Secrets for Actions:
   - Use the Output.
    - AZURE_CLIENT_ID: The Azure Service Principal's Application (client) ID. It is used for authenticating with the Azure Container Registry.
    - AZURE_ACR_ENDPOINT: The login server name of your Azure Container Registry. This is the URL where the Docker images will be pushed to.
8. Configure the Secret in App Registration "github_sp".
9. Set Secrets for Actions:
   - Use the secret created in step 8.
   - AZURE_CLIENT_SECRET: The Azure Service Principal's Secret. It is used along with the AZURE_CLIENT_ID for authentication.
10. Create a base file `.github/workflows/build.yaml`.
11. Load files into the Storage account:
    - Use files from the folder `sa_images`, `dev.png` and `main.png`.
12. Automatic Testing:
    - Use basic Bash testing:
      - `.github/workflows/build_w_test.yaml`
    - Use Python image testing:
      - `.github/workflows/build_w_all_test.yaml`
13. Use image changes from the mount.

## Usage

After deployment, the infrastructure will support your application, providing detailed logs on usage and errors, accessible through the Azure portal.

## Continuous Integration / Continuous Deployment

CI/CD is configured using ACR webhooks and GitHub actions or Azure Pipelines. Include any necessary steps to integrate with your existing CI/CD processes.

## Security

Security measures in place include the use of managed identities, access restrictions, and the secure handling of secrets.

## Contributing

We welcome contributions! Please read `CONTRIBUTING.md` for details on our code of conduct and the process for submitting pull requests to us.

## License

This project is licensed under no license.

### Customization Tips

- **Overview**: Provide a high-level description tailored to your project’s architecture and use case.
- **Repository Structure**: Update this based on the actual files and directories in your repository.
- **Deployment Instructions**: Be specific about any steps unique to your setup, like special configuration files or environment-specific settings.
- **Security**: Be clear about the security mechanisms in place, especially if you handle sensitive information.

This template is designed to be a starting point. You should adjust it according to the specifics of your project and the conventions you prefer.
