# InnovateMart Project Bedrock

## Overview
InnovateMart's Project Bedrock is an initiative to deploy a modern microservices-based retail store application on Amazon Elastic Kubernetes Service (EKS). This project aims to provide a scalable and efficient infrastructure to support InnovateMart's growth in the e-commerce sector.

## Architecture
The architecture consists of several microservices, each responsible for different functionalities of the retail store application. The key components include:

- **EKS Cluster**: The core of the infrastructure, hosting all microservices.
- **Managed Databases**:
  - **PostgreSQL** for the orders service (AWS RDS).
  - **MySQL** for the catalog service (AWS RDS).
  - **DynamoDB** for the carts service.
- **Kubernetes Resources**: Deployments, Services, ConfigMaps, and Secrets to manage application configurations and access.

## Deployment Instructions
To deploy the application, follow these steps:

1. **Prerequisites**:
   - Ensure you have AWS CLI and Terraform installed.
   - Configure your AWS credentials.

2. **Clone the Repository**:
   ```bash
   git clone <repository-url>
   cd innovatemart-project-bedrock
   ```

3. **Terraform Setup**:
   - Navigate to the Terraform environment:
     ```bash
     cd terraform/envs/sandbox
     ```
   - Initialize Terraform:
     ```bash
     terraform init
     ```
   - Review the planned changes:
     ```bash
     terraform plan
     ```
   - Apply the changes to provision the infrastructure:
     ```bash
     terraform apply
     ```

4. **Deploy the Application**:
   - Navigate to the scripts directory:
     ```bash
     cd ../../scripts
     ```
   - Run the deployment script:
     ```bash
     ./deploy-app.sh
     ```

## Accessing the Application
Once the deployment is complete, you can access the retail store application through the Application Load Balancer (ALB) URL provided in the Terraform outputs.

## Developer Access
A read-only IAM user has been created for the development team. Use the provided credentials to access the EKS cluster and view logs, pods, and services without making changes.

## Documentation
For detailed architecture, deployment steps, and cost management notes, refer to the documents in the `docs` directory:
- [ARCHITECTURE.md](docs/ARCHITECTURE.md)
- [DEPLOYMENT_GUIDE.md](docs/DEPLOYMENT_GUIDE.md)
- [COST_NOTES.md](docs/COST_NOTES.md)

## Conclusion
This project lays the foundation for InnovateMart's cloud infrastructure, enabling the team to deliver a world-class shopping experience to customers. Your contributions as a Cloud DevOps Engineer are crucial for the success of Project Bedrock.