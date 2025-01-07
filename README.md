# JTTW-AI Docker Stack

## Overview
Jesus Take the Wheel-AI Docker Stack: This project provides a comprehensive Docker-based development environment setup script (`setup.sh`) that configures multiple services for web development, monitoring, and AI capabilities. This is meant to be used in a Linux environment and should be compatible with Windows WSL environments. In the case of WSL environments it's recommended to use WSL2 and ensure you've enabled Docker access to Nvidia GPU support.

## WTF Does This Do
The script handles 
   - Version tagged docker images for each service
   - Separate docker services for ai, development, production, and monitoring
   - Secrets generation in the form of docker service specific .env files with appropriate environment variables
   - Automatic strong password generation for all services that use passwords, stored in service specific .env secrets files
   - Persistent data storage volume creation, and separate data directories configuration/assignment for each service
     - Base directory: (`~/.docker`)
     - Core directory: (`~/.docker/core`)
     - Core secrets directory: (`~/.docker/core/secrets`)
     - Core data directory: (`~/.docker/core/data`)
     - Production directory: (`~/.docker/production`)
     - Production secrets directory: (`~/.docker/production/secrets`)
     - Production data directory: (`~/.docker/production/data`)
     - Development directory: (`~/.docker/development`)
     - Development secrets directory: (`~/.docker/development/secrets`)
     - Development data directory: (`~/.docker/development/data`)
   - Initial LLM downloads for Ollama docker upon docker up:
     - [llama3.2:3b](https://ollama.com/library/llama3.2:3b) - For chat
     - [phi3.5:3.8b](https://ollama.com/library/phi3.5:3.8b) - For chat
     - [qwen2.5:7b](https://ollama.com/library/qwen2.5:7b) - For chat
     - [qwen2.5:14b](https://ollama.com/library/qwen2.5:14b) - For chat
     - [hhao/qwen2.5-coder-tools:32b](https://ollama.com/library/hhao/qwen2.5-coder-tools:32b) - For coding
     - [mxbai-embed-large](https://ollama.com/library/mxbai-embed-large) - For embedding/reading documents
   - Set up and configuration of SearxNG docker to allow both HTML and JSON response formats for web searches
   - Set up and configuration of OpenWebUI with access to Ollama docker service for AI interactions
   - Set up and configuration of OpenWebUI docker to allow LLM web searches using SearxNG
   - Set up and configuration of OpenWebUI docker to allow for embedding/reading documents using mxbai-embed-large
   - PGAdmin configured with access to production and development Postgres for managing those databases via web ui
   - PHPMyAdmin configured with access to production and development MariaDB for managing those databases via web ui
   - Healthchecks for all docker services ( except Portainer because fuck me I guess )
   - Dependency checks for various docker services
   - Logging
   - Deployment resource allocation and limits
   - Port exposure for various docker services so you can access them from outside the container
   - Network compartmentalization:
     - core_monitoring_network - Core Monitoring Network is used to monitor all of our services/docker containers
       - Portainer and all other docker services
     - core_remote_access_network - Core Remote Access Network is used for our remote access related services/docker containers ( In future updates Zrok, Caddy, Traefik )
     - core_ai_network - Core AI Network is used for our AI related services/docker containers
       - SearxNG
       - Ollama
       - OpenWebUI
     - production_app_network - Production App Network is used for our web application related services/docker containers
       - PHP Apache2
       - Postgres
       - MariaDB
       - Neo4j
       - SearxNG
       - Ollama
     - production_db_network - Production DB Network is used for our database related services/docker containers
       - Postgres
       - MariaDB
       - Neo4j
       - PGAdmin
       - PHPMyAdmin
     - development_app_network - Development App Network is used for our web application related services/docker containers
       - PHP Apache2
       - Postgres
       - MariaDB
       - Neo4j
       - SearxNG
       - Ollama
     - development_db_network - Development DB Network is used for our database related services/docker containers
       - Postgres
       - MariaDB
       - Neo4j
       - PGAdmin
       - PHPMyAdmin


## For the GPU Rich People

Look at you swinging your big dick with your GPU money. You get to run your language models at fullspeed ( provided you have enough VRAM ).

The following may be needed in order for Nvidia GPU cards to work with docker. If you have an AMD card I have no idea what you need to do.

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

## For the GPU Poor People

WOMP, WOMP, big dick GPU purchases were not on your bingo card this year. The good news is you can still use this docker stack with LLMs but they'll just respond slower than they would than if you had a GPU to cram them into VRAM. Using this method will limit your Ollama docker to using CPU and RAM only to run your LLMs so you'll want to make sure you have enough RAM.

The following modification needs to be done with the generated (`docker-compose.yml`) file after you've run the script.

You'll want to find the services section of the (`docker-compose.yml`) file and look for where the core_ollama service is defined.

You can perform this quickly by searching for (`container_name: core_ollama`)

Scroll down to the deploy section of the core_ollama service. That should will look like this:

```yaml
    deploy:
      resouresc:
        reservations:
          devices:
            - driver: nvidia
              count: all
              capabilities: [gpu]
        limits:
          memory: 64G
```

Remove the (`reservations`) section from the `deploy` section. Your deploy should now look like this:

```yaml
    deploy:
      resources:
        limits:
          memory: 64G
```

Then save the file and when you next bring the container up it should run with CPU support only.

```bash
docker-compose up -d --build
```


## Services Overview

### Core Services
1. **Portainer**
   - Docker management UI
   - Access: http://localhost:9000
   - Secrets Environment Variables File: ~/.docker/core/secrets/.portainer.env
   - Data Volume: ~/.docker/core/data/portainer
   - Project Page: https://github.com/portainer/portainer
   - Docker Image: [portainer/portainer-ce:2.21.4](https://hub.docker.com/layers/portainer/portainer-ce/2.21.4/images/sha256-a79ade2af4257a1a77e33fefdf06ec47606c0ce0dbff3146f6426c8a209908f4?context=explore)
   - Persistent data storage
   - Manages Docker containers and services

2. **SearxNG**
   - Privacy-respecting search engine
   - Access: 
     - HTTP: http://localhost:8084
   - Secrets Environment Variables File: ~/.docker/core/secrets/.searxng.env
   - Data Volume: ~/.docker/core/data/searxng
   - Project Page: https://github.com/searxng/searxng
   - Docker Image: [searxng/searxng:2024.12.16-65c970bdf](https://hub.docker.com/layers/searxng/searxng/2024.12.16-65c970bdf/images/sha256-4a13ed45abe2546765d2def2b23292ae46646c50d647758895ccea629f668a9c)
   - Persistent data storage
   - Installs pre-configured with support for both HTML and JSON search formats

3. **PGAdmin**
   - Web UI for Postgres database management
   - Access: 
     - HTTP: http://localhost:8082
   - Secrets Environment Variables File: ~/.docker/core/secrets/.pgadmin.env
   - Data Volume: ~/.docker/core/data/pgadmin
   - Project Page: https://github.com/pgadmin-org/pgadmin4
   - Docker Image: [dpage/pgadmin4:8.14.0](https://hub.docker.com/layers/dpage/pgadmin4/8.14.0/images/sha256-1053696a89c887a2a3ee6b24a7e2614cf68227d30ff8304e61da20bc71d4dd50)
   - Persistent data storage
   - Installs pre-configured with access to both production and development Postgres databases

4. **PHPMyAdmin**
   - Web UI for MariaDB database management
   - Access: 
     - HTTP: http://localhost:8083
   - Secrets Environment Variables File: ~/.docker/core/secrets/.phpmyadmin.env
   - Data Volume: ~/.docker/core/data/phpmyadmin
   - Project Page: https://github.com/phpmyadmin/phpmyadmin
   - Docker Image: [phpmyadmin/phpmyadmin:5.2.1](https://hub.docker.com/layers/phpmyadmin/phpmyadmin/5.2.1/images/sha256-67ba2550fd004399ab0b95b64021a88ea544011e566a9a1995180a3decb6410d)
   - Persistent data storage
   - Manages both production and development MariaDB instances
   - Installs pre-configured with access to production and development MariaDB databases

5. **Ollama**
   - Large Language Model (LLM) server
   - Access: 
     - HTTP: http://localhost:11434
   - Secrets Environment Variables File: ~/.docker/core/secrets/.ollama.env
   - Data Volume: ~/.docker/core/data/ollama
   - Project Page: https://github.com/ollama/ollama
   - Docker Image: [ollama/ollama:0.5.1](https://hub.docker.com/layers/ollama/ollama/0.5.1/images/sha256-bbe7b28a899f111df1de2ebd70de0f8c55746784038dd70d537c540df23f57c1)
   - Persistent data storage
   - Installs with support using multiple AI models including:
     - [mxbai-embed-large](https://ollama.com/library/mxbai-embed-large) for embedding/reading documents
     - [llama3.2:3b](https://ollama.com/library/llama3.2:3b) for chat
     - [phi3.5:3.8b](https://ollama.com/library/phi3.5:3.8b) for chat
     - [qwen2.5:7b](https://ollama.com/library/qwen2.5:7b) for chat
     - [qwen2.5:14b](https://ollama.com/library/qwen2.5:14b) for chat
     - [hhao/qwen2.5-coder-tools:32b](https://ollama.com/library/hhao/qwen2.5-coder-tools:32b) for coding

6. **OpenWebUI**
   - Web UI for LLMs 
   - Access: 
     - HTTP: http://localhost:11435
   - Secrets Environment Variables File: ~/.docker/core/secrets/.openwebui.env
   - Data Volume: ~/.docker/core/data/openwebui
   - Project Page: https://github.com/open-webui/open-webui
   - Docker Image: [ghcr.io/open-webui/open-webui:git-1dfb479](https://github.com/open-webui/open-webui/pkgs/container/open-webui/331304257?tag=git-1dfb479)
   - Persistent data storage
   - Integrates with Ollama for AI interactions
   - Installs pre-configured with websearch enabled using SearxNG
   - Installs pre-configured with embedding enabled using mxbai-embed-large embedding model

### Production Services
1. **PHP-fpm Apache2**
   - Production Web server
   - Access:
     - HTTP: http://localhost:8080
     - HTTPS: https://localhost:8443
   - Secrets Environment Variables File: ~/.docker/production/secrets/.phpfpm_apache.env
   - Data Volume: ~/.docker/production/data/phpfpm_apache
   - Project Page: https://github.com/shinsenter/php
   - Docker Image[shinsenter/phpfpm-apache:php8](https://hub.docker.com/layers/shinsenter/phpfpm-apache/php8/images/sha256-371fcee525c04dd95898bb2cf0590c8fa163402374d5141f75dcbbc6b3088e11)
   - Persistent data storage
   - Supports PHP applications

2. **Postgres**
   - Production database
   - Access: 
     - TCP: http://localhost:5432
   - Secrets Environment Variables File: ~/.docker/production/secrets/.postgres.env
   - Data Volume: ~/.docker/production/data/postgres
   - Project Page: https://github.com/postgres/postgres
   - Docker Image: [postgres:12.22](https://hub.docker.com/layers/library/postgres/12.22/images/sha256-25b2d01b1bb6c995ee5cd865019d030158309b7811ac5809060b6c69c4eaea2e)
   - Persistent data storage
   - Used for vector data

3. **MariaDB**
   - Production database
   - Access: 
     - TCP: http://localhost:3306
   - Secrets Environment Variables File: ~/.docker/production/secrets/.mariadb.env
   - Data Volume: ~/.docker/production/data/mariadb
   - Project Page: https://github.com/MariaDB/server
   - Docker Image: [mariadb:10.6](https://hub.docker.com/layers/library/mariadb/10.6/images/sha256-5e037317c5a20c7cde15ce4404e8f363ab39eddb3d72379eaa3a9db882efaf6d)
   - Persistent data storage
   - Used for traditional data

4. **Neo4j**
   - Production graph database
   - Access: 
     - HTTP: http://localhost:7474
     - BOLT: bolt://localhost:7687
   - Secrets Environment Variables File: ~/.docker/production/secrets/.neo4j.env
   - Data Volume: ~/.docker/production/data/neo4j
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
   - Secrets Environment Variables File: ~/.docker/development/secrets/.phpfpm_apache.env
   - Data Volume: ~/.docker/development/data/phpfpm_apache
   - Project Page: https://github.com/shinsenter/php
   - Docker Image: [shinsenter/phpfpm-apache:php8](https://hub.docker.com/layers/shinsenter/phpfpm-apache/php8/images/sha256-371fcee525c04dd95898bb2cf0590c8fa163402374d5141f75dcbbc6b3088e11)
   - Persistent data storage
   - Separate instance for development

2. **Postgres**
   - Development database
   - Access: 
     - TCP: http://localhost:5433
   - Secrets Environment Variables File: ~/.docker/development/secrets/.postgres.env
   - Data Volume: ~/.docker/development/data/postgres
   - Project Page: https://github.com/postgres/postgres
   - Docker Image: [postgres:12.22](https://hub.docker.com/layers/library/postgres/12.22/images/sha256-25b2d01b1bb6c995ee5cd865019d030158309b7811ac5809060b6c69c4eaea2e)
   - Persistent data storage
   - Separate instance for development
   - Isolated from production data

3. **MariaDB**
   - Development database
   - Access: 
     - TCP: http://localhost:3307
   - Secrets Environment Variables File: ~/.docker/development/secrets/.mariadb.env
   - Data Volume: ~/.docker/development/data/mariadb
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
   - Secrets Environment Variables File: ~/.docker/development/secrets/.neo4j.env
   - Data Volume: ~/.docker/development/data/neo4j
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

1. **Managing and Monitoring Services**
   - Use Portainer for container management and monitoring

2. **Database Management**
   - Use PGAdmin for PostgreSQL management
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

## TODO
   - Kicking around the notion of adding a pre-configured Zrok docker as a core service for secure zero trust reverse proxy tunneling as a method of making services remotely accessible over the web, we'll see. I may decide to go a different route for this functionality though, not sure yet. Zrok is pretty badass and there's no shortage of other uses it could serve for a stack like this. I'm particularly interested in the notion of a Zrok docker that generates static urls for each service that can be used to access the services over the web, with security features built in.
   - Thinking of adding a Caddy docker for certificate management and cert auto-renewal under core services.
   - Considering addition of a Traefik docker for routing and load balancing under core services. Trying to justify it.
   - May add a Redis docker for caching however it may be in the form of separate production and development Redis docker instances. I'm looking into web interfaces for managing Redis instances soooo if I decide to add Redis as a part of the stack I'll also have to consider the addition of a web interface for it.
   - In addition to these the following are also components I'm weighing making part of this stack.
     - TGI, llama.cpp or koboldcpp in addition to Ollama as part of the stack for when a package or framework is being fucky and not playing nicely with Ollama
     - LiteLLM, I've used prior to Ollama becoming plug-n-play with OpenAI compatible applications. I want to look into if this project would serve as good fit for this stack if it's no longer needed specifically for providing a layer of OpenAI compatibility for local LLMs.
     - Promptfoo or an adjacent project
     - Guidance or an adjacent project
     - Text-to-speech and/or Speech-to-text dockers
     - An image generation docker using SD Forge, SwarmUI, or something similar which can be accessed via a web interface and has an API that can be utilized to generate images

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
