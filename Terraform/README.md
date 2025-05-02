# NT548-Lab01: Deploying AWS Infrastructure using Terraform

## 🛠️ Prerequisites

Before starting, make sure you have the following:

1. **AWS Credentials**
   - Install and configure the AWS CLI with your IAM user's Access Key and Secret Key.

2. **SSH Key Pair**
   - Create a new SSH key pair using the EC2 Console.
   - Download and store the `.pem` private key file securely on your machine.

3. **Secrets Manager Setup**
   - Store your private key in AWS Secrets Manager as a plaintext secret.
   - Use either the AWS Console or CLI to create this secret.

> This project includes a startup script named `user-data.sh` located in `modules/ec2/`. This script is executed on the public EC2 instance upon boot. It automatically retrieves the private key from AWS Secrets Manager, saves it to the instance, and configures SSH access.  
> If you need to extend its behavior (e.g., install software or run commands), edit the `user-data.sh` file or create a custom `.sh` file inside the `/Terraform` folder and reference it in your instance configuration.

---

## 🚀 Deployment Instructions

### Step 1: Clone the Repository

Clone the project to your local environment and move into the Terraform directory:

```bash
git clone https://github.com/TranPio/NT548.P21-Lab01.git
cd NT548.P21-Lab01/Terraform
```

### Step 2: Initialize and Apply Terraform

Run Terraform to create all AWS infrastructure. Make sure you review and adjust values in `variables.tf` beforehand:

```bash
terraform init
terraform apply
```

> After applying, Terraform will output public and private IPs of your instances. Keep these handy for SSH access in the next steps.

---

## 🔐 SSH Access to EC2 Instances

### 1. Connect to the Public Instance

From your local machine, ensure your private key file is properly permissioned and initiate an SSH connection:

```bash
chmod 400 <private-key-file>
ssh -i <private-key-file> <username>@<public-ip>
```

> - `<private-key-file>`: Path to the downloaded `.pem` file  
> - `<username>`: Typically `ubuntu` for Ubuntu AMIs  
> - `<public-ip>`: The public IP assigned to the public instance

### 2. Connect to the Private Instance from the Public Instance

Once inside the public EC2 instance, navigate to the `.ssh` directory and use the saved private key to SSH into the private instance:

```bash
cd ~/.ssh
chmod 400 <private-key-file>
ssh -i <private-key-file> <username>@<private-ip>
```

> Note: The `user-data.sh` script ensures the private key is automatically downloaded and saved in the public instance’s `~/.ssh` directory. You can directly reuse that key for internal SSH access.

---

## 📁 Project Structure

```
Terraform/
├── main.tf
├── outputs.tf
├── variables.tf
├── versions.tf
├── modules/
│   ├── vpc/
│   ├── nat-gateway/
│   ├── route-tables/
│   ├── security-group/
│   └── ec2/
│       └── user-data.sh
```

---

## 📎 Project Information

- **Course**: DevOps and Applications (NT548.P21)  
- **Author**: Tran Hoai Phu and Team  
- **GitHub Repository**: [github.com/TranPio/NT548.P21-Lab01](https://github.com/TranPio/NT548.P21-Lab01)