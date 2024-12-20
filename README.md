# EKS Deployment with ArgoCD and Python Application

This repository demonstrates a complete CI/CD pipeline deploying a Python application to Amazon EKS using ArgoCD. The project showcases infrastructure as code with Terraform, containerization with Docker, and GitOps principles with ArgoCD.

## Project Structure

```plaintext
step_final/
├── app.py                     # Python Flask application
├── Dockerfile                 # Container image definition
├── requirements.txt           # Python dependencies
├── EKS/                       # Terraform configuration for EKS
│   ├── backend.tf             # S3 backend configuration
│   ├── provider.tf            # AWS provider setup
│   ├── variables.tf           # Variable definitions
│   ├── terraform.tfvars       # Variable values
│   ├── eks-cluster.tf         # EKS cluster configuration
│   ├── eks-worker-nodes.tf    # EKS node groups
│   ├── iam.tf                 # IAM roles and policies
│   ├── sg.tf                  # Security groups
│   └── ingress_controller.tf  # NGINX ingress setup
├── manifests/                 # Kubernetes manifests
│   ├── deployment.yaml        # Application deployment
│   ├── service.yaml           # Service configuration
│   └── ingress.yaml           # Ingress rules
└── .github/workflows/         # GitHub Actions
    ├── docker-build.yml       # Docker image build pipeline
    └── update-manifest.yml    # Manifest update automation
```

## Prerequisites

Before starting, ensure you have:
- AWS CLI installed and configured with appropriate credentials
- Terraform installed
- kubectl installed
- Access to a Docker Hub account
- GitHub account

## Customizing the Deployment

The project uses several key variables that you'll need to customize for your own deployment. These are currently set to:
- Profile: `danit`
- Student name: `yevhent`
- Domain: `devops4.test-danit.com`

In GitHub repository settings, add secrets:
- DOCKERHUB_USERNAME
- DOCKERHUB_TOKEN
- GITHUB_TOKEN (for automated updates)

In deployment.yaml, update the image repository:

    your-dockerhub-username/python-test-server:${GITHUB_SHA}

In ingress.yaml, update the host:

    app.YOUR_NAME.YOUR_DOMAIN

In python-app.yaml (ArgoCD application), update:

    repoURL: 'https://github.com/YOUR_USERNAME/YOUR_REPO.git'

In backend.tf, update:

    bucket = "your-bucket-name"     # Change to your S3 bucket name
    key    = "terraform.tfstate"    # Path to state file in bucket
    region = "your-region"          # Your AWS region (e.g., eu-central-1)
    
Important Notes:

The name variable is used as a prefix for most AWS resources

The profile should have appropriate AWS permissions

Changing these values after deployment may require recreating some resources

## Step-by-Step Setup
## 1. Infrastructure Setup

First, we need to create the EKS cluster and related AWS resources:

    terraform init -backend-config "region=your_region" -backend-config "profile=YOUR_PROFILE"
    terraform apply -var="iam_profile=YOUR_PROFILE" -var="name=YOUR_NAME"

This creates:
- EKS cluster with one node group
- VPC and networking components
- NGINX ingress controller
- ArgoCD installation
- Required IAM roles and policies

## 2. Docker Image Setup
The Python application is containerized and automatically built via GitHub Actions.

The CI pipeline (.github/workflows/docker-build.yml) automatically:
- Builds the Docker image
- Tags it with :latest and :${GITHUB_SHA}
- Pushes to Docker Hub

## 3. ArgoCD Configuration
    After infrastructure is ready:

        1.Get ArgoCD admin password:
        kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d
        
        2.Access ArgoCD UI:
        https://argocd.app.YOUR_NAME.YOUR_DOMAIN

        3.Apply the ArgoCD application manifest:
        kubectl apply -f argocd/python-app.yaml

## 4. Continuous Deployment
The system implements GitOps practices.
When code is pushed to main branch:
- GitHub Actions builds new Docker image
- Updates manifest with new image tag
- Commits changes back to repository
ArgoCD automatically:
- Detects manifest changes
- Synchronizes cluster state
- Deploys new version

## 5. Accessing the Application
The application is available at:

https://app.YOUR_NAME.YOUR_DOMAIN

## Making Changes
    
To update the application:
    
- Modify app.py 
- Commit and push changes

GitHub Actions will:
    
- Build new image
- Update deployment manifest
- ArgoCD will automatically deploy the new version

## Cleanup
To tear down the infrastructure:
    
    terraform destroy -var="iam_profile=YOUR_PROFILE"

## Architecture
The project implements a modern cloud-native architecture:

- EKS for container orchestration
- ArgoCD for GitOps deployment
- GitHub Actions for CI/CD
- NGINX Ingress for routing
- External DNS for automatic DNS management

## Security Considerations

- SSL/TLS encryption via AWS Certificate Manager
- IAM roles with least privilege
- Network security groups with minimal required access
- Kubernetes RBAC configurations

## Troubleshooting

Common issues and solutions
DNS Resolution Issues:
- Check Route53 records
- Verify External DNS pod status
ArgoCD Access Issues:
- Verify ingress configuration
- Check SSL certificate status
Application Deployment Issues:
- Check ArgoCD UI for sync status
- Verify pod logs and events
