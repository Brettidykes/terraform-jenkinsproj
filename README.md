# terraform-jenkinsproj
 
# Terraform Jenkins Deployment

## Overview

This project automates the deployment of a **Jenkins server on AWS EC2** using **Terraform**. It sets up the necessary security group, installs Jenkins on an Ubuntu instance, and creates an **S3 bucket for storing Jenkins artifacts**.

## Features

- **Deploys an EC2 instance** in the default VPC
- **Bootstraps Jenkins** using a Terraform-provisioned user data script
- **Configures a security group** to allow traffic on ports `22` (SSH) and `8080` (Jenkins UI)
- **Creates an S3 bucket** (private) for Jenkins artifacts
- **Ensures Jenkins binds to IPv4** for proper accessibility

## Prerequisites

- **Terraform v1.x.x** ([Download](https://developer.hashicorp.com/terraform/downloads))
- **AWS CLI** ([Install Guide](https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2.html))
- **AWS IAM User** with permissions for EC2, S3, and Security Groups
- **An existing EC2 key pair** (ensure you have access to the `.pem` file)

## Setup & Deployment

### **1️⃣ Clone This Repository**

```sh
git clone https://github.com/your-username/terraform-jenkins.git
cd terraform-jenkins
```

### **2️⃣ Configure Terraform Variables**

Edit the `terraform.tfvars` file (create it if missing):

```hcl
my_ip = "YOUR_PUBLIC_IP/32"
bucket_name = "my-jenkins-artifacts-bucket"
key_name = "your-aws-key-pair"
```

Alternatively, export environment variables:

```sh
export TF_VAR_my_ip=$(curl -4 -s ifconfig.me)
export TF_VAR_bucket_name="my-jenkins-artifacts-bucket"
export TF_VAR_key_name="your-aws-key-pair"
```

### **3️⃣ Initialize Terraform**

```sh
terraform init
```

### **4️⃣ Plan & Apply Deployment**

```sh
terraform plan -out=tfplan
terraform apply tfplan
```

### **5️⃣ Access Jenkins**

- Find your **Jenkins public IP**:
  ```sh
  terraform output jenkins_public_ip
  ```
- Open Jenkins in your browser:
  ```
  http://<PUBLIC_IP>:8080
  ```
- Retrieve the initial Jenkins admin password:
  ```sh
  sudo cat /var/lib/jenkins/secrets/initialAdminPassword
  ```

### **6️⃣ Destroy Infrastructure**

When finished, clean up resources:

```sh
terraform destroy -auto-approve
```

## Project Structure

```
terraform-jenkins/
├── main.tf              # Terraform configuration for EC2, Security Group, and S3
├── variables.tf         # Variable definitions
├── outputs.tf           # Outputs (Jenkins public IP, S3 bucket name)
├── providers.tf         # AWS provider configuration
├── userdata.sh          # Script to install and configure Jenkins
├── terraform.tfvars     # User-specific values (ignored in .gitignore)
├── README.md            # Project documentation
```

## Troubleshooting

- **Jenkins not accessible?**
  - Ensure **port 8080 is open** in your security group
  - Check if **Jenkins is listening on \*\*\*\*****`0.0.0.0`**:
    ```sh
    sudo netstat -tulnp | grep 8080
    ```
  - Restart Jenkins:
    ```sh
    sudo systemctl restart jenkins
    ```





