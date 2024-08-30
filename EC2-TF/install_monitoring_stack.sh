#!/bin/bash

# Created a Script to Automate the Installation Process
# of Prometheus, Node Exporter, and Grafana
# Exit script on error
set -e

# Function to create systemd service files
create_systemd_service() {
    local service_name="$1"
    local service_content="$2"
    local service_file="/etc/systemd/system/${service_name}.service"

    echo "$service_content" | sudo tee "$service_file" > /dev/null
}

# Function to display success or failure messages
check_status() {
    if [ $? -eq 0 ]; then
        echo "$1 installation completed successfully!"
    else
        echo "$1 installation failed!"
        exit 1
    fi
}

# Update Server
echo "Updating Server..."
sudo apt update > /dev/null

# 1. Install Prometheus
echo "Starting Prometheus installation..."

# Create Prometheus user
sudo useradd --system --no-create-home --shell /bin/false prometheus

# Download and extract Prometheus
wget https://github.com/prometheus/prometheus/releases/download/v2.47.1/prometheus-2.47.1.linux-amd64.tar.gz > /dev/null
tar -xvf prometheus-2.47.1.linux-amd64.tar.gz > /dev/null
rm prometheus-2.47.1.linux-amd64.tar.gz
mv prometheus-2.47.1.linux-amd64/ prometheus
cd prometheus/

# Move binaries and configuration files
sudo mkdir -p /data /etc/prometheus
sudo mv prometheus promtool /usr/local/bin/
sudo mv consoles/ console_libraries/ /etc/prometheus/
sudo mv prometheus.yml /etc/prometheus/prometheus.yml

# Set ownership
sudo chown -R prometheus:prometheus /etc/prometheus/ /data/

# Create Prometheus systemd service
PROMETHEUS_SERVICE="[Unit]
Description=Prometheus
Wants=network-online.target
After=network-online.target
StartLimitIntervalSec=500
StartLimitBurst=5

[Service]
User=prometheus
Group=prometheus
Type=simple
Restart=on-failure
RestartSec=5s
ExecStart=/usr/local/bin/prometheus \
  --config.file=/etc/prometheus/prometheus.yml \
  --storage.tsdb.path=/data \
  --web.console.templates=/etc/prometheus/consoles \
  --web.console.libraries=/etc/prometheus/console_libraries \
  --web.listen-address=0.0.0.0:9090 \
  --web.enable-lifecycle

[Install]
WantedBy=multi-user.target"

create_systemd_service "prometheus" "$PROMETHEUS_SERVICE"

# Enable and start Prometheus
sudo systemctl daemon-reload
sudo systemctl enable prometheus > /dev/null
sudo systemctl start prometheus > /dev/null
check_status "Prometheus"

# 2. Install Node Exporter
echo "Starting Node Exporter installation..."

# Create Node Exporter user
sudo useradd --system --no-create-home --shell /bin/false node_exporter

# Download and extract Node Exporter
wget https://github.com/prometheus/node_exporter/releases/download/v1.6.1/node_exporter-1.6.1.linux-amd64.tar.gz > /dev/null
tar -xvf node_exporter-1.6.1.linux-amd64.tar.gz > /dev/null

# Move the binary
sudo mv node_exporter-1.6.1.linux-amd64/node_exporter /usr/local/bin/
rm -rf node_exporter*

# Set ownership for directories:
sudo chown node_exporter:node_exporter /usr/local/bin/node_exporter

# Create Node Exporter systemd service
NODE_EXPORTER_SERVICE="[Unit]
Description=Node Exporter
After=network.target

[Service]
User=node_exporter
Group=node_exporter
Type=simple
ExecStart=/usr/local/bin/node_exporter

[Install]
WantedBy=default.target"

create_systemd_service "node_exporter" "$NODE_EXPORTER_SERVICE"

# Start and enable Node Exporter service:
sudo systemctl daemon-reload
sudo systemctl enable node_exporter > /dev/null
sudo systemctl start node_exporter > /dev/null
check_status "Node Exporter"

# Update Prometheus configuration to include Node Exporter and Jenkins
echo "Updating Prometheus configuration..."
sudo tee -a /etc/prometheus/prometheus.yml > /dev/null <<EOF
  - job_name: "node_exporter"
    static_configs:
      - targets: ["localhost:9100"]

  - job_name: "jenkins"
    metrics_path: '/prometheus'
    static_configs:
      - targets: ["localhost:8080"]
EOF

# 3. Install Grafana
echo "Starting Grafana installation..."

# Install Dependencies
sudo apt-get update > /dev/null
sudo apt-get install -y apt-transport-https software-properties-common > /dev/null

# Add the GPG Key for Grafana:
wget -q -O - https://packages.grafana.com/gpg.key | sudo apt-key add - > /dev/null

# Add Grafana repository:
echo "deb https://packages.grafana.com/oss/deb stable main" | sudo tee -a /etc/apt/sources.list.d/grafana.list > /dev/null

# Update the Package List and Install Grafana
sudo apt-get update > /dev/null
sudo apt-get -y install grafana > /dev/null

# Enable and start Grafana
sudo systemctl enable grafana-server > /dev/null
sudo systemctl start grafana-server > /dev/null
check_status "Grafana"

echo "All installations completed successfully!"

# a Check the validity of the configuration file →
#promtool check config /etc/prometheus/prometheus.yml

# b. Reload the Prometheus configuration without restarting →
#curl -X POST http://localhost:9090/-/reload
