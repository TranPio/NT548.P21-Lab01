#!/bin/bash
# Install AWS CLI (if not already installed)
sudo apt-get update
sudo apt-get install -y awscli

export AWS_DEFAULT_REGION=${aws_region}

# Create .ssh directory if it doesn't exist
sudo mkdir -p /home/ubuntu/.ssh

# Set correct permissions for .ssh directory
sudo chmod 700 /home/ubuntu/.ssh

# Retrieve the private key from AWS Secrets Manager
aws secretsmanager get-secret-value --secret-id ${secret_id} --query 'SecretString' --output text > /home/ubuntu/.ssh/${key_name}.pem

# Set correct permissions for the private key file
sudo chmod 600 /home/ubuntu/.ssh/${key_name}.pem

# Ensure ubuntu user owns the .ssh directory and files
sudo chown -R ubuntu:ubuntu /home/ubuntu/.ssh

# Add to SSH config for easy use
cat << EOF > /home/ubuntu/.ssh/config
Host *
  IdentityFile /home/ubuntu/.ssh/${key_name}.pem
  StrictHostKeyChecking no
EOF

sudo chmod 600 /home/ubuntu/.ssh/config
sudo chown ubuntu:ubuntu /home/ubuntu/.ssh/config