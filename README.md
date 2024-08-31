## Tetris Game Deployment on Kubernetes with Ansible and Jenkins
In this project, we will demonstrate the deployment of the Tetris game on Kubernetes using Ansible and Jenkins. Let's begin by running the following commands

```bash
# Clone the repository
git clone https://github.com/gyenoch/2048-App-Deployment-with-Ansible-Jenkins.git
cd 2048-App-Deployment-with-Ansible-Jenkins
```

```bash
# Move to EC2-TF directory and run commands to create Servers
terraform init
terraform apply
```
### Jenkins, Sonarqube, Prometheus, Node Exporter and Grafana Servers are Created
Copy IP Addresses and setup Servers in the browser

http://<IP-Address>:8080/  # Jenkins Server
http://<IP-Address>:9000/  # Sonarqube Server
http://<IP-Address>:9090/  # Prometheus Server
http://<IP-Address>:9100/  # Node Exporter Server
http://<IP-Address>:3000/  # Grafana Server

![Screenshot 2024-08-31 064629](https://github.com/user-attachments/assets/8da19939-f613-4664-accf-10915006b9a7)
