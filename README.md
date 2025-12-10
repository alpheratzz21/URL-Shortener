# URL Shortener – Flask, Nginx, Gunicorn, Terraform, GitHub Actions

A simple URL Shortener application built with Flask. This project demonstrates how to deploy a Python web application on **AWS EC2** using **Terraform (IaC)** and **GitHub Actions (CI/CD)**.

### Features
- Shortens long URLs into compact short links
- Stores URL mappings in a JSON file
- **Nginx** reverse proxy with Gunicorn WSGI server
- Automated deployment with GitHub Actions
- Infrastructure as Code with Terraform

### Tech Stack

* Python 3 (Flask)
* Gunicorn
* Nginx
* AWS EC2 (Ubuntu 22.04)
* Terraform
* GitHub Actions
* Git

### System Architecture

1. User sends a request to the EC2 instance (port 80).
2. Nginx receives the request and forwards it to Gunicorn.
3. Gunicorn runs the Flask application.
4. Flask reads/writes URL mappings from storage.json.
5. Terraform provisions EC2, security groups, and key pairs.
6. GitHub Actions deploys updates automatically on every push.
   
### Repository Structure
```
URL-Shortener/
│
├── app.py
├── requirements.txt
├── storage.json
├── nginx/
│   └── flask.conf
│
└── terraform/
    ├── main.tf
    ├── variables.tf
    ├── keypair.tf
    ├── security-group.tf
    └── outputs.tf
```
### Deploying with Terraform
1. Go to the Terraform directory
```cd terraform```

2. Initialize Terraform
```terraform init```

3. Preview the changes
```terraform plan```

4. Deploy infrastructure
```terraform apply```
5. When finished, Terraform will output the EC2 public IP address.

### CI/CD with GitHub Actions
Required GitHub Secrets
* **EC2_HOST** – EC2 public IP
* **EC2_USER** – usually ubuntu
* **EC2_SSH_KEY** – private key contents
* **EC2_APP_PATH** – example: ```/home/ubuntu/URL-Shortener```

### Workflow Summary

1. Triggered on every push to the main branch
2. GitHub Actions SSHs into EC2
3. Pulls updated code

### License
This project is free for personal use, study, and portfolio purposes.
5. Installs dependencies
6. Restarts Gunicorn service

This project is free to use for learning and portfolio purposes.
