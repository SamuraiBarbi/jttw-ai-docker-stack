# JTTW-AI Docker Stack

## Overview
This project provides a comprehensive Docker-based development environment setup script (`setup.sh`) that configures multiple services for web development, monitoring, and AI capabilities. The script handles directory creation, secret generation, initial LLM downloads llama3.2:3b, phi3.5:3.8b, qwen2.5:14b, and hhao/qwen2.5-coder-tools:32b including embedding model mxbai-embed-large, set up and configuration of OpenWebUI and SearxNG to allow LLM web searches using SearxNG. and Docker configuration.

## Services Overview

### Core Services
1. **Portainer**
   - Docker management UI
   - Access: http://localhost:9000
   - Manages Docker containers and services

2. **Prometheus**
   - Monitoring server
   - Access: http://localhost:9090
   - Collects and stores metrics from all services

3. **SearxNG**
   - Privacy-respecting search engine
   - Access: http://localhost:8083
   - Supports both HTML and JSON search formats

4. **PHPMyAdmin**
   - Database management tool
   - Access: http://localhost:8082
   - Manages both production and development MariaDB instances

5. **Ollama**
   - Large Language Model (LLM) server
   - Access: http://localhost:11434
   - Supports multiple AI models including:
     - mxbai-embed-large
     - llama3.2:3b
     - phi3.5:3.8b
     - qwen2.5:14b
     - hhao/qwen2.5-coder-tools:32b

6. **OpenWebUI**
   - Web interface for LLMs
   - Access: http://localhost:11435
   - Integrates with Ollama for AI interactions

### Production Services
1. **PHP-fpm Apache2**
   - Web server
   - Access: http://localhost:8080
   - Supports PHP applications

2. **MariaDB**
   - Production database
   - Access: http://localhost:3306
   - Persistent data storage

3. **Neo4j**
   - Graph database
   - Access: http://localhost:7474
   - Used for knowledge graphs and AI memory augmentation

### Development Services
1. **PHP-fpm Apache2**
   - Development web server
   - Access: http://localhost:8081
   - Separate instance for development

2. **MariaDB**
   - Development database
   - Access: http://localhost:3307
   - Isolated from production data

3. **Neo4j**
   - Development graph database
   - Access: http://localhost:7475
   - Separate instance for development

## Setup Instructions

1. **Prerequisites**
   - Docker and Docker Compose installed
   - NVIDIA GPU drivers (for Ollama GPU support)
   - Sufficient system resources (RAM, CPU)

2. **Installation**
   ```bash
   bash setup.sh
   ```

3. **Starting Services**
   ```bash
   docker-compose up -d --build
   ```

4. **Accessing Services**
   - Use the provided URLs to access each service
   - Default ports are configured to avoid conflicts

## Usage Guidelines

1. **Managing Services**
   - Use Portainer for container management
   - Monitor services through Prometheus

2. **Database Management**
   - Use PHPMyAdmin for MariaDB management
   - Access Neo4j through its web interface

3. **AI Development**
   - Interact with LLMs through OpenWebUI
   - Use Ollama's API for programmatic access

## Maintenance

1. **Backups**
   - Regularly back up `/opt/docker` directory
   - Use Docker volume backups for databases

2. **Updates**
   - Update Docker images regularly
   - Review and update environment files as needed

3. **Monitoring**
   - Use Prometheus for system monitoring
   - Set up alerts for critical services

## Troubleshooting

1. **Service Not Starting**
   - Check logs: `docker logs <container_name>`
   - Verify resource availability

2. **Connection Issues**
   - Check port conflicts
   - Verify network configurations

3. **AI Model Issues**
   - Check GPU availability for Ollama
   - Verify model downloads

## Security Considerations

1. **Secrets Management**
   - Environment files are stored in `/opt/docker/*/secrets`
   - Ensure proper file permissions

2. **Network Security**
   - Services are isolated by network
   - Use appropriate firewall rules

3. **Access Control**
   - Use strong passwords generated by the script
   - Limit access to management interfaces

## Customization

1. **Configuration Files**
   - Modify environment files in `/opt/docker/*/secrets`
   - Adjust Docker Compose settings as needed

2. **Adding Services**
   - Extend the Docker Compose file
   - Create appropriate directories and secrets

## Contributing

1. **Reporting Issues**
   - Open issues on the project repository
   - Include detailed error logs

2. **Feature Requests**
   - Submit feature requests with use cases
   - Consider security implications

3. **Code Contributions**
   - Follow existing code style
   - Include comprehensive documentation

## License
This project is licensed under the MIT License. See the LICENSE file for details.
