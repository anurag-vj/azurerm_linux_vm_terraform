# SonarQube Public Hosted on Azure 🐳

Infrastructure as Code (IaC) for deploying SonarQube Community Edition on Azure Virtual Machine using Terraform and Docker. This configuration creates a fully automated SonarQube server with public access for code quality analysis.

## 📋 Overview

This Terraform project deploys a production-ready SonarQube instance on Azure infrastructure:

- **Ubuntu 22.04 LTS VM** with automated Docker installation
- **SonarQube Community Edition** running in Docker container
- **Public IP access** for web interface and analysis endpoints
- **Automated deployment** with cloud-init configuration
- **Azure networking** with configurable security groups

## 🏗️ Architecture

```
Azure Subscription
├── Resource Group (rg-sonarqube)
│   ├── Virtual Network (vnet-sonarqube)
│   │   └── Subnet (snet-vnet-sonarqube: 10.10.10.0/29)
│   ├── Network Security Group (nsg-sonarqube)
│   │   └── Security Rule (Allow all inbound TCP)
│   ├── Public IP (pip-sonarqube) [Static]
│   ├── Network Interface (nic-sonarqube)
│   └── Linux VM (vm-sonarqube)
│       ├── Ubuntu 22.04 LTS
│       ├── Docker Engine
│       └── SonarQube Container (Port 9000)
```

## 📁 Project Structure

```
sonarqube-public-hosted-terraform/
├── terraform/
│   ├── main.tf                 # Azure infrastructure resources
│   ├── variable.tf             # Input variables
│   ├── output.tf               # Output values
│   ├── provider.tf            # Azure provider configuration
│   ├── terraform.tfvars       # Default variable values
│   └── sonarqube_docker.yaml   # Cloud-init Docker setup script
├── LICENSE                     # MIT License
└── README.md                   # This documentation
```

## 🚀 Features

### Infrastructure
- **Ubuntu 22.04 LTS**: Latest LTS with long-term support
- **Docker Installation**: Automated Docker CE setup with Compose
- **Network Security**: Configurable NSG with public access
- **Static Public IP**: Consistent endpoint for SonarQube access

### SonarQube
- **Community Edition**: Free, open-source code quality platform
- **Docker Container**: Isolated, portable deployment
- **Web Interface**: Access via port 9000
- **Analysis Endpoints**: REST API for CI/CD integration

### Automation
- **Cloud-init**: Automated VM provisioning
- **Terraform**: Infrastructure as Code
- **One-click Deployment**: Complete setup with single command

## 🛠️ Prerequisites

### Required Tools
- **Terraform 1.0+**: Infrastructure provisioning
- **Azure CLI**: Authentication and account management
- **Git**: Repository cloning

### Azure Requirements
- **Active Subscription**: Azure account with resource creation permissions
- **Service Principal**: For automated authentication (recommended)
- **Resource Quota**: Sufficient VM and networking quotas

## 🚀 Quick Start

### 1. Clone Repository
```bash
git clone https://github.com/anurag-devops-principles/sonarqube-public-hosted-terraform.git
cd sonarqube-public-hosted-terraform/terraform
```

### 2. Azure Authentication
```bash
# Login to Azure
az login

# Set subscription (optional, if multiple subscriptions)
az account set --subscription "your-subscription-id"
```

### 3. Configure Variables
Edit `terraform.tfvars` with your settings:
```hcl
name            = "sonarqube"
location        = "centralindia"
enable_pip      = true
vm_password     = "your-secure-password"
subscription_id = "your-subscription-id"
```

### 4. Deploy Infrastructure
```bash
# Initialize Terraform
terraform init

# Validate configuration
terraform validate

# Plan deployment
terraform plan

# Apply configuration
terraform apply
```

### 5. Access SonarQube
Once deployment completes, access SonarQube at:
```
http://<public-ip>:9000
```

Default credentials:
- **Username**: admin
- **Password**: admin

## 📋 Detailed Configuration

### Infrastructure Variables

| Variable | Type | Description | Default |
|----------|------|-------------|---------|
| `name` | string | Resource name prefix | `sonarqube` |
| `location` | string | Azure region | `centralindia` |
| `enable_pip` | bool | Enable public IP | `true` |
| `vm_password` | string | VM admin password | `rootadmin@123` |
| `subscription_id` | string | Azure subscription ID | - |

### VM Specifications
- **Size**: Standard_B2s (2 vCPUs, 4 GiB RAM)
- **OS**: Ubuntu 22.04 LTS (Jammy Jellyfish)
- **Storage**: 30 GiB Standard SSD
- **Admin User**: rootadmin

### Network Configuration
- **VNet Address Space**: 10.10.10.0/24
- **Subnet Range**: 10.10.10.0/29
- **NSG**: Allows all inbound TCP traffic (configure for production)

## 🔧 SonarQube Configuration

### Docker Container Setup
The `sonarqube_docker.yaml` script performs:
1. **System Updates**: Package updates and upgrades
2. **Docker Installation**: Complete Docker CE setup
3. **User Permissions**: Add admin user to docker group
4. **Container Deployment**: Run SonarQube community edition

### Accessing SonarQube
- **Web UI**: `http://<vm-ip>:9000`
- **API Endpoint**: `http://<vm-ip>:9000/api`
- **Health Check**: `http://<vm-ip>:9000/api/system/health`

### Initial Setup
1. **Login**: Use admin/admin credentials
2. **Change Password**: Update default password immediately
3. **Create Projects**: Set up your first code analysis project
4. **Configure Quality Gates**: Define code quality standards

## 📊 Monitoring & Management

### VM Access
```bash
# SSH into the VM
ssh rootadmin@<public-ip>

# Check Docker containers
docker ps

# View SonarQube logs
docker logs sonarqube
```

### SonarQube Logs
```bash
# Container logs
docker logs -f sonarqube

# System logs
sudo journalctl -u cloud-init
```

### Resource Monitoring
- **Azure Portal**: Monitor VM metrics, network traffic, and costs
- **SonarQube UI**: Built-in system monitoring and metrics
- **Docker Stats**: Container resource usage

## 🔒 Security Considerations

### Production Recommendations
- **NSG Rules**: Restrict inbound traffic to specific IPs/ports
- **VM Password**: Use strong, unique passwords or SSH keys
- **Network Isolation**: Deploy in private subnets with VPN access
- **SSL/TLS**: Configure HTTPS for production use
- **Backup Strategy**: Regular database and configuration backups

### SonarQube Security
- **Admin Password**: Change from default immediately
- **User Management**: Implement proper authentication
- **Quality Gates**: Enforce security-related rules
- **Regular Updates**: Keep SonarQube and Docker images updated

## 🧹 Cleanup

### Destroy Infrastructure
```bash
# Navigate to terraform directory
cd terraform

# Destroy all resources
terraform destroy

# Confirm destruction with 'yes'
```

### Data Backup (if needed)
```bash
# SSH into VM before destruction
ssh rootadmin@<public-ip>

# Backup SonarQube data (if using persistent volumes)
docker exec sonarqube tar czf /opt/sonarqube/backup.tar.gz /opt/sonarqube/data
```

## 🤝 Contributing

1. **Fork the repository**
2. **Create feature branch**: `git checkout -b feature/enhancement`
3. **Make changes**: Update Terraform configurations or documentation
4. **Test deployment**: Validate changes work correctly
5. **Submit PR**: Open pull request with detailed description

## 📝 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- **SonarQube Community**: For providing excellent code quality tools
- **Docker**: Containerization platform enabling easy deployment
- **Ubuntu**: Reliable Linux distribution
- **Azure**: Cloud infrastructure platform

## 📞 Support

For issues or questions:
- Check [SonarQube Documentation](https://docs.sonarsource.com/sonarqube/)
- Review Azure Terraform provider docs
- Create an issue in this repository

---

**Made by Anurag Vijay**

*Automate your code quality analysis with SonarQube on Azure*
