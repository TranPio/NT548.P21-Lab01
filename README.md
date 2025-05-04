# Công nghệ DevOps và ứng dụng - NT548.P21

Đây là repository của bài thực hành môn **Công nghệ DevOps và ứng dụng - NT548.P21** của **nhóm 10**.

## Thành viên nhóm 10:

| STT | Họ và tên           | MSSV     |
|-----|---------------------|----------|
| 1   | Trần Hoài Phú       | 22521106 |
| 2   | Lê Ngọc Kiều Anh    | 22520047 |
| 3   | Tăng Dũng Cẩm       | 22520141 |
| 4   | Phạm Đức Anh        | 22520067 |

---

# Lab 01: Dùng Terraform và CloudFormation để quản lý và triển khai hạ tầng AWS
## 🧑‍💻 Contributors

- Trần Hoài Phú – Terraform modules
- Lê Ngọc Kiều Anh – Nested modules integration
- Tăng Dũng Cẩm – VPC, NAT Gateway, Route Tables
- Phạm Đức Anh – EC2 & Security Groups

## ✅ Self-Evaluation

- Time Spent: 2 Weeks  
- Team Coordination: Successful  
- Completion: 100% of Terraform requirements met  

# NT548.P21-Lab01 – Deploy AWS Infrastructure using Terraform

## 📌 Introduction

This repository demonstrates how to build a secure, modular, and scalable AWS network infrastructure using **Terraform**. It includes public/private subnets, NAT Gateway, security groups, and EC2 instances.

> 📁 GitHub repository link (required by assignment):  
> https://github.com/TranPio/NT548.P21-Lab01

## 📂 Project Structure

```
NT548.P21-Lab01/
├── Terraform/
│   ├── main.tf
│   ├── variables.tf
│   ├── outputs.tf
│   ├── modules/
│   │   ├── vpc/
│   │   ├── nat-gateway/
│   │   ├── route-tables/
│   │   ├── security-group/
│   │   └── ec2/
│   │       └── user-data.sh
├── Image/
│   ├── fig1.png  # Hình 1: Tạo resource VPC
│   ├── fig9.png  # Hình 9: Tạo resource Nat Gateway
│   ├── fig13.png # Hình 13: Tạo Private Route Table
│   ├── fig17.png # Hình 17: Tạo Security Group cho Private Instance
│   ├── fig22.png # Hình 22: Tạo resource EC2 Instance
│   ├── fig33.png # Hình 33: SSH thành công đến Public Instance
│   └── fig35.png # Hình 35: SSH từ Public đến Private Instance
```

## 🧰 Prerequisites

1. **AWS Credentials**  
   Install and configure the AWS CLI with IAM user credentials.

2. **SSH Key Pair**  
   Create via EC2 Console. Store the private key (`.pem`) securely.

3. **Secrets Manager**  
   Save your `.pem` as a plaintext secret in AWS Secrets Manager.  
   Script `user-data.sh` will automatically download and use this key at instance boot.

## 🚀 Deployment Instructions

1. **Clone the repository**

```bash
git clone https://github.com/TranPio/NT548.P21-Lab01.git
cd NT548.P21-Lab01/Terraform
```

2. **Configure variables** in `variables.tf`, especially:
   - `project_name`
   - `create_new_keypair`
   - `existing_key_name`

3. **Deploy infrastructure**

```bash
terraform init
terraform apply
```

> ✅ After apply, note the outputs: public/private IPs, instance IDs, etc.

## 🛰️ Steps to SSH to Instances

After applying all nested modules, you will see an output similar to the one below, which includes public and private IPs for each instance.

📸 **Hình 29** – Kết quả sau khi chạy `terraform apply` hiển thị output của các instance  
![Terraform Output](Image/fig29.png)

### Example Output (interpreted):

- `instance_private_ips`:  
  - `192.168.1.251` → Private IP of **Public Instance**  
  - `192.168.2.140` → Private IP of **Private Instance**

- `instance_public_ips`:  
  - `13.251.48.2` → Public IP of **Public Instance**

---

### 🔐 SSH to Public Instance

To connect to your public EC2 instance, follow these steps:

1. Locate your private key file (`.pem`)
2. Ensure proper permission:
```bash
chmod 400 <private-key-file>
```
3. SSH into the public instance:
```bash
ssh -i <private-key-file> <username>@<public-ip>
```

---

### 🔐 SSH to Private Instance (via Public)

Once you're inside the **public instance**, follow these steps:

1. Navigate to the SSH directory:
```bash
cd ~/.ssh
```
2. Run:
```bash
chmod 400 <private-key-file>
ssh -i <private-key-file> <username>@<private-ip>
```

> ✅ The file `user-data.sh` automatically retrieves your private key from AWS Secrets Manager and places it in `~/.ssh/` to simplify this process.

## 📸 Diagrams and Screenshots

**Image 1** – This image shows the creation of a VPC using Terraform. The configuration includes CIDR blocks, DNS settings, and resource tagging.  
![VPC Creation](Image/fig1.png)

---

**Image 2** – This diagram illustrates how the NAT Gateway is provisioned in a public subnet and linked with an Elastic IP. It enables instances in the private subnet to securely access the internet.  
![NAT Gateway](Image/fig9.png)

---

**Image 3** – Here we configure a private route table that routes all external traffic through the NAT Gateway. This is essential for outbound internet access from private instances.  
![Private Route Table](Image/fig13.png)

---

**Image 4** – The image demonstrates the setup of a private security group. It allows SSH access only from EC2 instances in the public subnet (bastion host model), enhancing security.  
![Private Security Group](Image/fig17.png)

---

**Image 5** – This setup shows both EC2 instances: one in a public subnet with Elastic IP, and one in a private subnet. The `user-data.sh` script is used to fetch keys automatically for internal SSH.  
![EC2 Setup](Image/fig22.png)

---

**Image 6** – The output confirms that we successfully SSH into the public EC2 instance using a valid private key and IP address.  


![SSH Public Instance](Image/fig33.png)

---

**Image 7** – Once inside the public instance, we can SSH into the private instance using the key retrieved from AWS Secrets Manager, validating internal network connectivity.  
![SSH to Private from Public](Image/fig35.png)


# NT548.P21-Lab01 – Deploy AWS Infrastructure using CloudFormation

## Project Structure
```
CloudFormation/
├── .vscode/
│ └── settings.json
├── modules/
│ ├── ec2/
│ │ └── ec2.yaml
│ ├── security-group/
│ ├── nat-gateway.yaml
│ ├── route-tables.yaml
│ └── vpc.yaml
├── test/
│ ├── ec2/
│ │ └── ec2_test_script.ps1
│ ├── security-group/
│ ├── nat-gateway_script.ps1
│ ├── route-table_script.ps1
│ └── vpc_script.ps1
└── root.yaml
```

## Prerequisites

1. **AWS Credentials**  
   Install and configure the AWS CLI with IAM user credentials.

2. **SSH Key Pair**  
   Create via EC2 Console. Store the private key (`.pem`) securely.

3. **Secrets Manager**  
   Save your `.pem` as a plaintext secret in AWS Secrets Manager.

## Deployment Instructions

1. **Clone the repository**

```bash
git clone https://github.com/TranPio/NT548.P21-Lab01.git
cd NT548.P21-Lab01/CloudFormation
```
   
## Create Stacks

```bash
aws cloudformation create-stack --stack-name <stackname> --template-body file://root.yaml
```

All stacks created successfully.
![create stack](Image/fig70.png)

## 🛰️ Steps to SSH to Instances

### 🔐 SSH to Public Instance

To connect to your public EC2 instance, follow these steps:
1. Locate your private key file (`.pem`)
![copy file .pem](Image/fig77.png)

2. Ensure proper permission:
```bash
chmod 400 <private-key-file>
```

3. SSH into the public instance
```bash
ssh -i <your-private-key> ec2-user@<your-public-instance-ip>
```
![SSH to Public Instance](Image/fig74.png)


### 🔐 SSH to Private Instance 

Once you're inside the **public instance**, follow these steps:

1. Navigate to the SSH directory:
```bash
cd ~/.ssh
```

2. Run:
```bash
chmod 400 <private-key-file>
ssh -i <your-private-key> ec2-user@<your-private-instance-privateip>
```
![SSH vào EC2 Public](Image/fig75.png)

Từ Public Instance SSH thành công đến Private Instance:
![SSH to Private Instance](Image/fig76.png)


