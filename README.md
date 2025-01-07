# JTTW-AI Docker Stack

## Overview
Jesus Take the Wheel-AI Docker Stack: This project provides a comprehensive Docker-based development environment setup script (`setup.sh`) that configures multiple services for web development, monitoring, and AI capabilities. The script handles directory creation, secret generation, initial LLM downloads llama3.2:3b, phi3.5:3.8b, qwen2.5:7b, qwen2.5:14b, and hhao/qwen2.5-coder-tools:32b including embedding model mxbai-embed-large, set up and configuration of OpenWebUI and SearxNG to allow LLM web searches using SearxNG. and Docker configuration.

```bash
curl -fsSL https://nvidia.github.io/libnvidia-container/gpgkey | sudo gpg --dearmor -o /usr/share/keyrings/nvidia-container-toolkit-keyring.gpg \
  && curl -s -L https://nvidia.github.io/libnvidia-container/stable/deb/nvidia-container-toolkit.list | \
    sed 's#deb https://#deb [signed-by=/usr/share/keyrings/nvidia-container-toolkit-keyring.gpg] https://#g' | \
    sudo tee /etc/apt/sources.list.d/nvidia-container-toolkit.list
sudo apt-get update
sudo apt-get install -y nvidia-container-toolkit

distribution=$(. /etc/os-release;echo $ID$VERSION_ID)
curl -s -L https://nvidia.github.io/nvidia-docker/gpgkey | sudo apt-key add -
curl -s -L https://nvidia.github.io/nvidia-docker/$distribution/nvidia-docker.list | sudo tee /etc/apt/sources.list.d/nvidia-docker.list
sudo apt-get update
sudo apt-get install -y nvidia-docker2
sudo systemctl restart docker
```

## Services Overview

### Core Services
1. **Portainer**
   - Docker management UI
   - Access: http://localhost:9000
   - Environment Variables: ~/.docker/core/secrets/.portainer.env
   - Project Page: https://github.com/portainer/portainer
   - Docker Image: [portainer/portainer-ce:2.21.4](https://hub.docker.com/layers/portainer/portainer-ce/2.21.4/images/sha256-a79ade2af4257a1a77e33fefdf06ec47606c0ce0dbff3146f6426c8a209908f4?context=explore)
   
   - Manages Docker containers and services

2. **Prometheus**
   - Monitoring server
   - Access: 
     - HTTP: http://localhost:9090
   - Environment Variables: ~/.docker/core/secrets/.prometheus.env
   - Project Page: https://github.com/prometheus/prometheus
   - Docker Image: [prom/prometheus:v3.0.1](https://hub.docker.com/layers/prom/prometheus/v3.0.1/images/sha256-c4af82c47edf60ab4da6ce28d9686bc641860b86004fe382ff7ab7d1f1510d47)
   - Collects and stores metrics from all services

3. **SearxNG**
   - Privacy-respecting search engine
   - Access: 
     - HTTP: http://localhost:8084
   - Environment Variables: ~/.docker/core/secrets/.searxng.env
   - Project Page: https://github.com/searxng/searxng
   - Docker Image: [searxng/searxng:2024.12.16-65c970bdf](https://hub.docker.com/layers/searxng/searxng/2024.12.16-65c970bdf/images/sha256-4a13ed45abe2546765d2def2b23292ae46646c50d647758895ccea629f668a9c)
   - Installs with support for both HTML and JSON search formats

4. **PGAdmin**
   - Web UI for postgres database management
   - Access: 
     - HTTP: http://localhost:8082
   - Environment Variables: ~/.docker/core/secrets/.pgadmin.env
   - Project Page: https://github.com/pgadmin-org/pgadmin4
   - Docker Image: [dpage/pgadmin4:8.14.0](https://hub.docker.com/layers/dpage/pgadmin4/8.14.0/images/sha256-1053696a89c887a2a3ee6b24a7e2614cf68227d30ff8304e61da20bc71d4dd50)
   - Manages both production and development Postgres instances

5. **PHPMyAdmin**
   - Web UI for mariadb database management
   - Access: 
     - HTTP: http://localhost:8083
   - Environment Variables: ~/.docker/core/secrets/.phpmyadmin.env
   - Project Page: https://github.com/phpmyadmin/phpmyadmin
   - Docker Image: [phpmyadmin/phpmyadmin:5.2.1](https://hub.docker.com/layers/phpmyadmin/phpmyadmin/5.2.1/images/sha256-67ba2550fd004399ab0b95b64021a88ea544011e566a9a1995180a3decb6410d)
   - Manages both production and development MariaDB instances

6. **Ollama**
   - Large Language Model (LLM) server
   - Access: 
     - HTTP: http://localhost:11434
   - Environment Variables: ~/.docker/core/secrets/.ollama.env
   - Project Page: https://github.com/ollama/ollama
   - Docker Image: [ollama/ollama:0.5.1](https://hub.docker.com/layers/ollama/ollama/0.5.1/images/sha256-bbe7b28a899f111df1de2ebd70de0f8c55746784038dd70d537c540df23f57c1)
   - Installs with support using multiple AI models including:
     - mxbai-embed-large for embedding/reading documents
     - llama3.2:3b for chat
     - phi3.5:3.8b for chat
     - qwen2.5:7b for chat
     - qwen2.5:14b for chat
     - hhao/qwen2.5-coder-tools:32b for coding
   - Installs pre-configured with websearch enabled using SearxNG

7. **OpenWebUI**
   - Web interface for LLMs
   - Access: 
     - HTTP: http://localhost:11435
   - Environment Variables: ~/.docker/core/secrets/.openwebui.env
   - Project Page: https://github.com/open-webui/open-webui
   - Docker Image: [ghcr.io/open-webui/open-webui:git-1dfb479](https://github.com/open-webui/open-webui/pkgs/container/open-webui/331304257?tag=git-1dfb479)
   - Integrates with Ollama for AI interactions

### Production Services
1. **PHP-fpm Apache2**
   - Web server
   - Access:
     - HTTP: http://localhost:8080
     - HTTPS: https://localhost:8443
   - Environment Variables: ~/.docker/production/secrets/.phpfpm_apache.env
   - Project Page: https://github.com/shinsenter/php
   - Docker Image[shinsenter/phpfpm-apache:php8](https://hub.docker.com/layers/shinsenter/phpfpm-apache/php8/images/sha256-371fcee525c04dd95898bb2cf0590c8fa163402374d5141f75dcbbc6b3088e11)
   - Persistent data storage
   - Supports PHP applications

2. **Postgres**
   - Production database
   - Access: 
     - TCP: http://localhost:5432
   - Environment Variables: ~/.docker/production/secrets/.postgres.env
   - Project Page: https://github.com/postgres/postgres
   - Docker Image: [postgres:12.22](https://hub.docker.com/layers/library/postgres/12.22/images/sha256-25b2d01b1bb6c995ee5cd865019d030158309b7811ac5809060b6c69c4eaea2e)
   - Persistent data storage
   - Used for vector data

3. **MariaDB**
   - Production database
   - Access: 
     - TCP: http://localhost:3306
   - Environment Variables: ~/.docker/production/secrets/.mariadb.env
   - Project Page: https://github.com/MariaDB/server
   - Docker Image: [mariadb:10.6](https://hub.docker.com/layers/library/mariadb/10.6/images/sha256-5e037317c5a20c7cde15ce4404e8f363ab39eddb3d72379eaa3a9db882efaf6d)
   - Persistent data storage
   - Used for traditional data

4. **Neo4j**
   - Graph database
   - Access: 
     - HTTP: http://localhost:7474
     - BOLT: bolt://localhost:7687
   - Environment Variables: ~/.docker/production/secrets/.neo4j.env
   - Project Page: https://github.com/neo4j/neo4j
   - Docker Image: [neo4j:5.26.0-community](https://hub.docker.com/layers/library/neo4j/5.26.0-community/images/sha256-4c59f45618c46b3e189d9ec36242c51396a9180ea7c494a89769671a535771d3)
   - Persistent data storage
   - Used for knowledge graphs and AI memory augmentation

### Development Services
1. **PHP-fpm Apache2**
   - Development web server
   - Access: 
     - HTTP: http://localhost:8081
     - HTTPS: https://localhost:8444
   - Environment Variables: ~/.docker/development/secrets/.phpfpm_apache.env
   - Project Page: https://github.com/shinsenter/php
   - Docker Image: [shinsenter/phpfpm-apache:php8](https://hub.docker.com/layers/shinsenter/phpfpm-apache/php8/images/sha256-371fcee525c04dd95898bb2cf0590c8fa163402374d5141f75dcbbc6b3088e11)
   - Persistent data storage
   - Separate instance for development

2. **Postgres**
   - Development database
   - Access: 
     - TCP: http://localhost:5433
   - Environment Variables: ~/.docker/development/secrets/.postgres.env
   - Project Page: https://github.com/postgres/postgres
   - Docker Image: [postgres:12.22](https://hub.docker.com/layers/library/postgres/12.22/images/sha256-25b2d01b1bb6c995ee5cd865019d030158309b7811ac5809060b6c69c4eaea2e)
   - Persistent data storage
   - Separate instance for development
   - Isolated from production data

3. **MariaDB**
   - Development database
   - Access: 
     - TCP: http://localhost:3307
   - Environment Variables: ~/.docker/development/secrets/.mariadb.env
   - Project Page: https://github.com/MariaDB/server
   - Docker Image: [mariadb:10.6](https://hub.docker.com/layers/library/mariadb/10.6/images/sha256-5e037317c5a20c7cde15ce4404e8f363ab39eddb3d72379eaa3a9db882efaf6d)
   - Persistent data storage
   - Separate instance for development
   - Isolated from production data

4. **Neo4j**
   - Development graph database
   - Access: 
     - HTTP: http://localhost:7475
     - BOLT: bolt://localhost:7688
   - Environment Variables: ~/.docker/development/secrets/.neo4j.env
   - Project Page: https://github.com/neo4j/neo4j
   - Docker Image: [neo4j:5.26.0-community](https://hub.docker.com/layers/library/neo4j/5.26.0-community/images/sha256-4c59f45618c46b3e189d9ec36242c51396a9180ea7c494a89769671a535771d3)
   - Persistent data storage
   - Separate instance for development
   - Isolated from production data

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
   - Regularly back up `$HOME/.docker` directory
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
   - Environment files are stored in `$HOME/.docker/*/secrets`
   - Ensure proper file permissions

2. **Network Security**
   - Services are isolated by network
   - Use appropriate firewall rules

3. **Access Control**
   - Use strong passwords generated by the script
   - Limit access to management interfaces

## Customization

1. **Configuration Files**
   - Modify environment files in `$HOME/.docker/*/secrets`
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
