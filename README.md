[![LinkedIn](https://img.shields.io/badge/Connect%20with%20me%20on-LinkedIn-blue.svg)](https://www.linkedin.com/in/gyenoch/)
[![Medium](https://img.shields.io/badge/Medium-12100E?style=for-the-badge&logo=medium&logoColor=white)](https://medium.com/@www.gyenoch)

![Screenshot 2024-08-31 092048](https://github.com/user-attachments/assets/8487ba3a-d031-4ad7-a8c6-38b830096147)

Welcome to the 2048-game Application Deployment project! 🚀

## Tetris Game Deployment on Kubernetes with Ansible and Jenkins
In this project, we will demonstrate the deployment of the Tetris game on Kubernetes using Ansible and Jenkins. Let's begin by running the following commands

## Table of Contents
- [Ansible](#Ansible)
- [EC2-TF](#EC2-TF)
- [EKS-TF](#EKS-TF)
- [Jenkins](#Jenkins)
- [Deployment File](#Deployment-File)
- [Project Details](#project-details)

## Ansible
The `Ansible` directory contains the source code to build, tag and push docker image to DockerHub and deploy it to the EKS cluster ensuring seamless deployment. It leverage the use of AWS Secret Manager for Docker Credential handling.

## EC2-TF
The `EC2-TF` directory contains the source code to create two EC2 Instances, for Jenkins, Sonarqube, Ansible, Promethues, Node Exporter and Grafana and many other tools. Installation scripts will be use to install all this tools and softwares seamlessly.

## EKS-TF
The `EKS-TF` directory contains the source code to create EKS cluster, Node Group for our kubernetes deployment

## Jenkins
The `Jenkins` directory contains the source code to create Jenkins pipeline for our our EKS cluster creation and kubernetes deployment. It contains to pipeline source code.

## Deployment File 
The `Deployment File` is find in the root directory which contains deployment instructions to kubernetes

## Project Details
🛠️ **Tools Explored:**
- Terraform, GitHub Action & AWS CLI for AWS infrastructure
- Jenkins, Sonarqube, Terraform, Ansible, Kubectl, and more for CI/CD setup
- Prometheus, and Grafana for Monitoring
- AWS Secret Manager for secure credential handling

📈 **The journey covered everything from setting up tools to deploying a 2048-game app, implementing CI/CD pipelines and using Prometheus and Grafana monitoring.**

## Getting Started
To get started with this project, refer to our [comprehensive guide](https://medium.com/@www.gyenoch/devsecops-approach-deploy-tetris-game-on-eks-with-jenkins-and-ansible-15f83ae276f4) that walks you through infrastructure provisioning, CI/CD pipeline configuration, EKS cluster creation, and more.

## Contributing
We welcome contributions! If you have ideas for enhancements or find any issues, please open a pull request or file an issue.

Happy Coding! 🚀

![Screenshot 2024-08-31 064629](https://github.com/user-attachments/assets/8da19939-f613-4664-accf-10915006b9a7)
