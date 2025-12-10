#URL Shortener – Flask, Nginx, Gunicorn, Terraform, GitHub Actions

A simple URL Shortener application built with Flask. This project demonstrates how to deploy a Python web application to AWS EC2 using Terraform for infrastructure provisioning and GitHub Actions for CI/CD automation.

Features

Shortens long URLs into compact short links

Stores data in a JSON file

Nginx reverse proxy with Gunicorn WSGI server

Automated deployment using GitHub Actions

Infrastructure as Code using Terraform

Tech Stack

Python 3, Flask

Gunicorn

Nginx

AWS EC2 (Ubuntu 22.04)

Terraform

GitHub Actions

Git

System Architecture

User sends HTTP request to EC2 instance (port 80).

Nginx receives the request and proxies it to Gunicorn.

Gunicorn runs the Flask application.

Flask reads and writes data via storage.json.

Terraform provisions EC2 instance, security group, and key pair.

GitHub Actions automates updates whenever new code is pushed.

Repository Structure
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

Deploying with Terraform

Enter the terraform directory

cd terraform


Initialize Terraform

terraform init


Preview changes

terraform plan


Deploy resources

terraform apply


After deployment, the EC2 public IP will be shown in the output.

CI/CD with GitHub Actions
Setup

Add these GitHub repository secrets:

EC2_HOST

EC2_USER (ex: ubuntu)

EC2_SSH_KEY (private key contents)

EC2_APP_PATH (ex: /home/ubuntu/URL-Shortener)

Workflow Summary

Triggered on every push to main

GitHub Actions connects to EC2 via SSH

Pulls latest code

Installs dependencies

Restarts Gunicorn service

Files You Should Not Upload to GitHub

Private keys (*.pem)

terraform.tfstate and terraform.tfstate.backup

.ssh/ directory

Environment variables or sensitive config files

Credentials, tokens, or logs with private information

Minimum Terraform Files Required for Deployment

main.tf

variables.tf

security-group.tf

keypair.tf (optional if key already exists)

outputs.tf

Suggested Screenshots for Portfolio or CV

Application UI

Terraform apply output

AWS EC2 instance running

Nginx running (systemctl status)

Gunicorn running

GitHub Actions successful workflow

Browser test of short URL

License

This project is free for personal use, study, and portfolio purposes.