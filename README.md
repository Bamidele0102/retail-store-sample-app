Skip to content
Navigation Menu
Bamidele0102
retail-store-sample-app

Type / to search
Code
Issues
Pull requests
Actions
Projects
Wiki
Security
Insights
Settings
retail-store-sample-app
/
README.md
in
feature/innovatemart-branch

Edit

Preview

Show Diff
InnovateMart Project Bedrock
Overview
InnovateMart's Project Bedrock is an initiative to deploy a modern microservices-based retail store application on Amazon Elastic Kubernetes Service (EKS). This project aims to provide a scalable and efficient infrastructure to support InnovateMart's growth in the e-commerce sector.

UI Home
UI Home

Architecture
The architecture consists of several microservices, each responsible for different functionalities of the retail store application. The key components include:

EKS Cluster: The core of the infrastructure, hosting all microservices.
Managed Databases:
PostgreSQL for the orders service (AWS RDS).
MySQL for the catalog service (AWS RDS).
DynamoDB for the carts service.
Kubernetes Resources: Deployments, Services, ConfigMaps, and Secrets to manage application configurations and access.
Deployment Instructions
To deploy the application, follow these steps:

Prerequisites:

Ensure you have AWS CLI and Terraform installed.
Configure your AWS credentials.
Clone the Repository:

git clone https://github.com/Bamidele0102/retail-store-sample-app.git
cd retail-store-sample-app/innovatemart-project-bedrock


3. **Terraform Setup** (sandbox then operators):
- Sandbox (VPC, EKS, RDS, DynamoDB, IAM):
  ```bash
  cd terraform/envs/sandbox
  terraform init
  terraform plan
  terraform apply
  ```
- Operators (ALB controller, ExternalDNS, ESO, IRSA wiring):
  ```bash
  cd ../operators
  terraform init
  terraform plan
  terraform apply
  ```

4. **Deploy the Application**:
Run the deployment script (pick one based on your current directory):
- From the repo root:
  ```bash
  ./innovatemart-project-bedrock/scripts/deploy-app.sh
  ```
- From inside `innovatemart-project-bedrock/`:
  ```bash
  ./scripts/deploy-app.sh
  ```

Note: The CI workflows (Plan/Apply) also run both stacks in order: sandbox first, then operators, followed by the Kubernetes deploy script.

## Accessing the Application
Once the deployment is complete, you can access the retail store application through the Application Load Balancer (ALB) URL provided in the Terraform outputs. If ALB creation is restricted in your account, see the Challenges section below for the NodePort + Route 53 workaround we used.

## Challenges and Workarounds

### ALB restrictions in the account
- In this sandbox account, creating an AWS Application Load Balancer (ALB) was blocked (service-linked role/ALB limits). As a result, we couldn’t use Ingress + ALB for the UI service.

### NodePort fallback for UI exposure
- We exposed the UI via a NodePort Service on port 30080 (`ui-nodeport`). You can reach the app at:
- http://<NODE_PUBLIC_IP>:30080/
- File reference: `innovatemart-project-bedrock/k8s/base/services/ui-nodeport.yaml`.

### Route 53 DNS wrapper (friendly name)
- We created Route 53 A record(s) in the hosted zone pointing directly to the EKS worker node public IP(s). This provides a stable hostname while using NodePort.
- Tips:
- Add two A records (both node public IPs) for basic resilience.
- Use a low TTL (e.g., 60s) to tolerate node replacements.
- Access remains over HTTP on port 30080 (no TLS) in this mode.

### Trade-offs
- Node public IPs can change on scale/drain/upgrade—A records must be updated (or automated).
- ALB features (TLS termination via ACM, health checks, WAF, etc.) are not available with this fallback.

### Path back to proper HTTPS/port 80
- When ALB restrictions are lifted, switch to Ingress + ALB + ACM. ExternalDNS will manage DNS automatically and you can remove the NodePort + direct A record approach.

For detailed steps and CLI examples, see `innovatemart-project-bedrock/docs/Deployment_Architecture_Guide.md` (section on NodePort fallback and Route 53 A records).


## Developer Access
A read-only IAM user has been created for the development team. Use the provided credentials to access the EKS cluster and view logs, pods, and services without making changes.

## Documentation
For detailed architecture, deployment steps, CI/CD, and cost notes, see:
- [ARCHITECTURE.md](innovatemart-project-bedrock/docs/ARCHITECTURE.md)
- [DEPLOYMENT_GUIDE.md](innovatemart-project-bedrock/docs/DEPLOYMENT_GUIDE.md)
- [CI_CD.md](innovatemart-project-bedrock/docs/CI_CD.md)
- [COST_NOTES.md](innovatemart-project-bedrock/docs/COST_NOTES.md)

## CI/CD (GitHub Actions + AWS OIDC)

We use GitHub Actions with OpenID Connect (OIDC) to assume an AWS role at run time (no long-lived keys). The pipelines are:

- Terraform Plan: Runs on feature/* (and PRs to main) when Terraform paths change. Jobs:
- Detect changes → Plan sandbox → Plan operators → Upload plans as artifacts.
- Terraform Apply: Runs on pushes to main. Jobs:
- Detect changes → Apply sandbox (if tf changed) → Apply operators (if tf changed) → Deploy k8s (if tf or k8s changed).
- The deploy step generates kubeconfig and applies k8s manifests via `innovatemart-project-bedrock/scripts/deploy-app.sh`.

Configuration highlights:
- Secrets/vars: `AWS_ROLE_TO_ASSUME` (role ARN), `AWS_REGION` (Actions variable).
- Least-privilege IAM policy allows plans/reads and selected actions (e.g., Secrets Manager read, ACM tag list). Policy JSON: `innovatemart-project-bedrock/terraform/scripts/iam/terraform-plan-readonly-policy.json`.
- First run: create an EKS Access Entry for the Actions role to avoid Kubernetes provider Unauthorized during operators apply (see `innovatemart-project-bedrock/terraform/scripts/create-eks-access-entry.sh`).

## Demo

![Demo][assets/demo.mp4](https://github.com/user-attachments/assets/8d0fa326-12f0-4110-aea5-ea0d393b61cf)

## Conclusion
This project lays the foundation for InnovateMart's cloud infrastructure, enabling the team to deliver a world-class shopping experience to customers. Your contributions as a Cloud DevOps Engineer are crucial for the success of Project Bedrock.
Editing retail-store-sample-app/README.md at feature/innovatemart-branch · Bamidele0102/retail-store-sample-app