#!/bin/bash

# Color codes for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Project configuration
PROJECT_NAME="webdev"
PROJECT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

USER_UID=$(id -u $USER)
USER_GID=$(id -g $USER)

# Logging function
log() {
  echo -e "$(date '+%Y-%m-%d %H:%M:%S') ${GREEN}[SETUP]${NC} $1"
}

# Error handling function
error() {
  echo -e "${RED}[ERROR]${NC} $1"
  exit 1
}

# Function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Function to check if a service exists
service_exists() {
    systemctl list-unit-files "$1.service" >/dev/null 2>&1
}

# Function to check if a package is installed
package_installed() {
    dpkg -l "$1" >/dev/null 2>&1
}

# Create project core structure
create_project_structure() {
  log "Creating project core directory structure..."
  
  # Create base directories
  sudo mkdir -p /opt/docker || error "Failed to create base directory."
  sudo chown -R $USER:$USER /opt/docker || error "Failed to set ownership for /opt/docker."

  sudo -u $USER mkdir -p /opt/docker/{core,production,development}/{data,secrets} || error "Failed to create base directories."

  # Create core service directories
  sudo -u $USER mkdir -p /opt/docker/core/data/{portainer,prometheus,searxng,phpmyadmin,ollama,openwebui} || error "Failed to create core service directories."

  # Create production service directories
  sudo -u $USER mkdir -p /opt/docker/production/data/{phpfpm_apache,mariadb,neo4j} || error "Failed to create production service directories."

  # Create development service directories
  sudo -u $USER mkdir -p /opt/docker/development/data/{phpfpm_apache,mariadb,neo4j} || error "Failed to create development service directories."

  # Set permissions
  sudo -u $USER chmod -R 755 /opt/docker/ || error "Failed to set permissions for /opt/docker/."

  log "Project directory structure created successfully."  
}

# Function to generate a random string
generate_random_string() {
  openssl rand -base64 32 | tr -d '/+=' | cut -c1-32
}

# Generate secure passwords
generate_secrets() {
  log "Generating secure secrets..."
  
  # Core secrets
  if [ ! -f "/opt/docker/core/secrets/.portainer.env" ]; then
    sudo -u $USER touch /opt/docker/core/secrets/.portainer.env || error "Failed to create core .portainer.env."
    echo "PORTAINER_ADMIN_PASSWORD=$(generate_random_string)" > /opt/docker/core/secrets/.portainer.env || error "Failed to write PORTAINER_ADMIN_PASSWORD to core .portainer.env."
  fi

  if [ ! -f "/opt/docker/core/secrets/.prometheus.env" ]; then
    sudo -u $USER touch /opt/docker/core/secrets/.prometheus.env || error "Failed to create core .prometheus.env."
    echo "PROMETHEUS_PASSWORD=$(generate_random_string)" > /opt/docker/core/secrets/.prometheus.env || error "Failed to write PROMETHEUS_PASSWORD to core .prometheus.env."
  fi

  if [ ! -f "/opt/docker/core/secrets/.searxng.env" ]; then
    sudo -u $USER touch /opt/docker/core/secrets/.searxng.env || error "Failed to create core .searxng.env."
    echo "SEARXNG_BASE_URL=http://localhost:8083" > /opt/docker/core/secrets/.searxng.env || error "Failed to write BASE_URL to core .searxng.env."
    echo "INSTANCE_NAME=JTTW SearxNG" >> /opt/docker/core/secrets/.searxng.env || error "Failed to write INSTANCE_NAME to core .searxng.env."
    echo "UWSGI_WORKERS=4" >> /opt/docker/core/secrets/.searxng.env || error "Failed to write UWSGI_WORKERS to core .searxng.env."
    echo "UWSGI_THREADS=4" >> /opt/docker/core/secrets/.searxng.env || error "Failed to write UWSGI_THREADS to core .searxng.env."
    echo "SEARXNG_SEARCH_FORMATS=html,json" >> /opt/docker/core/secrets/.searxng.env || error "Failed to write SEARXNG_SETTINGS_SEARCH__FORMATS to core .searxng.env."
    echo "SEARXNG_SEARCH_DEFAULT_FORMAT=html" >> /opt/docker/core/secrets/.searxng.env || error "Failed to write SEARXNG_SETTINGS_SEARCH__DEFAULT_FORMAT to core .searxng.env."
  fi

  if [ ! -f "/opt/docker/core/secrets/.phpmyadmin.env" ]; then    
    sudo -u $USER touch /opt/docker/core/secrets/.phpmyadmin.env || error "Failed to create core .phpmyadmin.env."
    echo "PMA_HOSTS=production_mariadb,development_mariadb" > /opt/docker/core/secrets/.phpmyadmin.env || error "Failed to write PMA_HOSTS to core .phpmyadmin.env."
    echo "PMA_PORTS=3306,3306" >> /opt/docker/core/secrets/.phpmyadmin.env || error "Failed to write PMA_PORTS to core .phpmyadmin.env."    
    # echo "PMA_PMADB=development_mariadb" >> /opt/docker/core/secrets/.phpmyadmin.env || error "Failed to write PMA_PMADB to core .phpmyadmin.env."
    # echo "PMA_CONTROLUSER=pma" >> /opt/docker/core/secrets/.phpmyadmin.env || error "Failed to write PMA_CONTROLUSER to core .phpmyadmin.env."
    # echo "PMA_CONTROLPASS=$(generate_random_string)" >> /opt/docker/core/secrets/.phpmyadmin.env || error "Failed to write PMA_CONTROLPASS to core .phpmyadmin.env."
  fi

  if [ ! -f "/opt/docker/core/secrets/.ollama.env" ]; then
    sudo -u $USER touch /opt/docker/core/secrets/.ollama.env || error "Failed to create core .ollama.env."
    echo "OLLAMA_FLASH_ATTENTION=1" > /opt/docker/core/secrets/.ollama.env || error "Failed to write OLLAMA_FLASH_ATTENTION to core .ollama.env."
  fi

  if [ ! -f "/opt/docker/core/secrets/.openwebui.env" ]; then
    sudo -u $USER touch /opt/docker/core/secrets/.openwebui.env || error "Failed to create core .openwebui.env."
    echo "WEBUI_SECRET_KEY=$(generate_random_string)" >> /opt/docker/core/secrets/.openwebui.env || error "Failed to write WEBUI_SECRET_KEY to core .openwebui.env."    
    echo "OLLAMA_BASE_URLS=http://core_ollama:11434" > /opt/docker/core/secrets/.openwebui.env || error "Failed to write OLLAMA_BASE_URLS to core .openwebui.env."
    echo "RAG_EMBEDDING_ENGINE=ollama" >> /opt/docker/core/secrets/.openwebui.env || error "Failed to write RAG_EMBEDDING_ENGINE to core .openwebui.env."
    echo "RAG_OLLAMA_BASE_URL=http://core_ollama:11434" >> /opt/docker/core/secrets/.openwebui.env || error "Failed to write RAG_OPENAI_API_BASE_URL to core .openwebui.env."
    echo "RAG_EMBEDDING_MODEL=mxbai-embed-large" >> /opt/docker/core/secrets/.openwebui.env || error "Failed to write RAG_EMBEDDING_MODEL to core .openwebui.env."
    echo "ENABLE_RAG_WEB_SEARCH=True" >> /opt/docker/core/secrets/.openwebui.env || error "Failed to write ENABLE_RAG_WEB_SEARCH to core .openwebui.env."
    echo "ENABLE_SEARCH_QUERY=True" >> /opt/docker/core/secrets/.openwebui.env || error "Failed to write ENABLE_SEARCH_QUERY to core .openwebui.env."
    echo "RAG_WEB_SEARCH_ENGINE=duckduckgo" >> /opt/docker/core/secrets/.openwebui.env || error "Failed to write RAG_WEB_SEARCH_ENGINE to core .openwebui.env."
    # To enable searxng searching, we need to uncomments the following lines and edit the searxng /opt/docker/core/data/searxng/settings.yml file to add json to formats:
    # echo "RAG_WEB_SEARCH_ENGINE=searxng" >> /opt/docker/core/secrets/.openwebui.env || error "Failed to write RAG_WEB_SEARCH_ENGINE to core .openwebui.env."
    # echo "SEARXNG_QUERY_URL=http://core_searxng:8083/search?q=<query>" >> /opt/docker/core/secrets/.openwebui.env || error "Failed to write SEARXNG_QUERY_URL to core .openwebui.env."
    # echo "RAG_WEB_SEARCH_RESULT_COUNT=3" >> /opt/docker/core/secrets/.openwebui.env || error "Failed to write RAG_WEB_SEARCH_RESULT_COUNT to core .openwebui.env."
    # echo "RAG_WEB_SEARCH_CONCURRENT_REQUESTS=10" >> /opt/docker/core/secrets/.openwebui.env || error "Failed to write RAG_WEB_SEARCH_CONCURRENT_REQUESTS to core .openwebui.env."
  fi



  # Production secrets
  if [ ! -f "/opt/docker/production/secrets/.mariadb.env" ]; then
    sudo -u $USER touch /opt/docker/production/secrets/.mariadb.env || error "Failed to create production .mariadb.env."
    echo "MARIADB_ROOT_PASSWORD=$(generate_random_string)" > /opt/docker/production/secrets/.mariadb.env || error "Failed to write MARIADB_ROOT_PASSWORD to production .mariadb.env."
    echo "MARIADB_DATABASE=production" >> /opt/docker/production/secrets/.mariadb.env || error "Failed to write MARIADB_DATABASE to production .mariadb.env."
    echo "MARIADB_USER=production_user" >> /opt/docker/production/secrets/.mariadb.env || error "Failed to write MARIADB_USER to production .mariadb.env."
    echo "MARIADB_PASSWORD=$(generate_random_string)" >> /opt/docker/production/secrets/.mariadb.env || error "Failed to write MARIADB_PASSWORD to production .mariadb.env."
  fi

  if [ ! -f "/opt/docker/production/secrets/.neo4j.env" ]; then
    sudo -u $USER touch /opt/docker/production/secrets/.neo4j.env || error "Failed to create production .neo4j.env."
    echo "NEO4J_AUTH=neo4j/$(generate_random_string)" > /opt/docker/production/secrets/.neo4j.env || error "Failed to write NEO4J_AUTH to production .neo4j.env."    
  fi

  if [ ! -f "/opt/docker/production/secrets/.phpfpm_apache.env" ]; then
    sudo -u $USER touch /opt/docker/production/secrets/.phpfpm_apache.env || error "Failed to create production .phpfpm_apache.env."
    echo "PHP_FPM_PASSWORD=$(generate_random_string)" > /opt/docker/production/secrets/.phpfpm_apache.env || error "Failed to write PHP_FPM_PASSWORD to production .phpfpm_apache.env."
    echo "APACHE2_PASSWORD=$(generate_random_string)" >> /opt/docker/production/secrets/.phpfpm_apache.env || error "Failed to write APACHE2_PASSWORD to production .phpfpm_apache.env." 
    
  fi



  # Development secrets
  if [ ! -f "/opt/docker/development/secrets/.mariadb.env" ]; then
    sudo -u $USER touch /opt/docker/development/secrets/.mariadb.env || error "Failed to create development .mariadb.env."
    echo "MARIADB_ROOT_PASSWORD=$(generate_random_string)" > /opt/docker/development/secrets/.mariadb.env || error "Failed to write MARIADB_ROOT_PASSWORD to development .mariadb.env."
    echo "MARIADB_DATABASE=development" >> /opt/docker/development/secrets/.mariadb.env || error "Failed to write MARIADB_DATABASE to development .mariadb.env."
    echo "MARIADB_USER=development_user" >> /opt/docker/development/secrets/.mariadb.env || error "Failed to write MARIADB_USER to development .mariadb.env."
    echo "MARIADB_PASSWORD=$(generate_random_string)" >> /opt/docker/development/secrets/.mariadb.env || error "Failed to write MARIADB_PASSWORD to development .mariadb.env."
  fi

  if [ ! -f "/opt/docker/development/secrets/.neo4j.env" ]; then
    sudo -u $USER touch /opt/docker/development/secrets/.neo4j.env || error "Failed to create development.neo4j.env."
    echo "NEO4J_AUTH=neo4j/$(generate_random_string)" > /opt/docker/development/secrets/.neo4j.env || error "Failed to write NEO4J_AUTH to development .neo4j.env."
  fi

  if [ ! -f "/opt/docker/development/secrets/.phpfpm_apache.env" ]; then
    sudo -u $USER touch /opt/docker/development/secrets/.phpfpm_apache.env || error "Failed to create development .phpfpm_apache.env."
    echo "PHP_FPM_PASSWORD=$(generate_random_string)" > /opt/docker/development/secrets/.phpfpm_apache.env || error "Failed to write PHP_FPM_PASSWORD to development .phpfpm_apache.env."
    echo "APACHE2_PASSWORD=$(generate_random_string)" >> /opt/docker/development/secrets/.phpfpm_apache.env || error "Failed to write APACHE2_PASSWORD to development .phpfpm_apache.env."
      
  fi

  # Set specific permissions for secrets directories
  sudo -u $USER chmod -R 700 /opt/docker/*/secrets/ || error "Failed to set permissions for secrets directories."

  log "Secrets generated and stored successfully"
}

# Create Docker configuration files
# TODO: Add zrok for zero-trust tunneling on remote_access_nework
# TODO: Add TGI v3 for llm long context handling on ai_network
# TODO: Add tiredofit/docker-db-backup for database backups
# FIX: OpenWebUI healthcheck is failing despite service functioning fine
# TODO: automatically had ollama pull specific models when container is first created qwen2.5:7b, qwen2.5-coder:7b, llama3.2:3b, llama3.2-vision:11b-instruct-q4_K_M
create_docker_configs() {
log "Creating Docker configuration files..."

cat > docker-compose.yml << EOF
# sudo -S docker compose down --remove-orphans
# sudo -S docker system prune -af
# sudo -S docker ps -a && echo '=== Images ===' && echo darkness | sudo -S docker images && echo '=== Networks ===' && echo darkness | sudo -S docker network ls
# sudo rm -rf /opt/docker/*
# cd /mnt/d/backup/local_files/Documents/WSL && bash docker-setup-script-v1.1.sh
# cd /mnt/d/backup/local_files/Documents/WSL && sudo -S docker compose up -d
# docker logs production_mariadb
# docker exec core_ollama ollama list
volumes:
# Core volumes
  host_core_storage_volume:
    driver: local
    driver_opts:
      type: none
      device: /opt/docker/core/
      o: bind    
  host_core_secrets_volume:
    driver: local
    driver_opts:
      type: none
      device: /opt/docker/core/secrets/
      o: bind
  host_core_portainer_storage_volume:
    driver: local
    driver_opts:
      type: none
      device: /opt/docker/core/data/portainer/
      o: bind
  host_core_prometheus_storage_volume:
    driver: local
    driver_opts:
      type: none
      device: /opt/docker/core/data/prometheus/
      o: bind      
  host_core_searxng_storage_volume:
    driver: local
    driver_opts:
      type: none
      device: /opt/docker/core/data/searxng/
      o: bind
  host_core_phpmyadmin_storage_volume:
    driver: local
    driver_opts:
      type: none
      device: /opt/docker/core/data/phpmyadmin/
      o: bind
  host_core_ollama_storage_volume:
    driver: local
    driver_opts:
      type: none
      device: /opt/docker/core/data/ollama/
      o: bind
  host_core_openwebui_storage_volume:
    driver: local
    driver_opts:
      type: none
      device: /opt/docker/core/data/openwebui/
      o: bind          
      
# Production volumes
  host_production_secrets_volume:
    driver: local
    driver_opts:
      type: none
      device: /opt/docker/production/secrets/
      o: bind   
  host_production_phpfpm_apache_storage_volume:
    driver: local
    driver_opts:
      type: none
      device: /opt/docker/production/data/phpfpm_apache/
      o: bind
  host_production_mariadb_storage_volume:
    driver: local
    driver_opts:
      type: none
      device: /opt/docker/production/data/mariadb/
      o: bind
  host_production_neo4j_storage_volume:
    driver: local
    driver_opts:
      type: none
      device: /opt/docker/production/data/neo4j/
      o: bind

# Development volumes
  host_development_secrets_volume:
    driver: local
    driver_opts:
      type: none
      device: /opt/docker/development/secrets/
      o: bind 
  host_development_phpfpm_apache_storage_volume:
    driver: local
    driver_opts:
      type: none
      device: /opt/docker/development/data/phpfpm_apache/
      o: bind
  host_development_mariadb_storage_volume:
    driver: local
    driver_opts:
      type: none
      device: /opt/docker/development/data/mariadb/
      o: bind
  host_development_neo4j_storage_volume:
    driver: local
    driver_opts:
      type: none
      device: /opt/docker/development/data/neo4j/
      o: bind


x-logging: &default-logging
  driver: "json-file"
  options:
    max-size: "1m"
    max-file: "1"
    tag: "{{.Name}}/{{.ID}}"  

x-common_phpfpm_apache: &common_phpfpm_apache
  image: shinsenter/phpfpm-apache:php8
  restart: unless-stopped
  deploy:
    resources:
      limits:
        cpus: '0.50'
        memory: 512M
  depends_on:
    core_prometheus:
      condition: service_healthy 

x-common_mariadb: &common_mariadb        
  image: mariadb:10.6
  restart: unless-stopped
  deploy:
    resources:
      limits:
        cpus: '1.0'
        memory: 1G
  depends_on:
    core_prometheus:
      condition: service_healthy

x-common_neo4j: &common_neo4j
  image: neo4j:5.7.0-community
  restart: unless-stopped
  deploy:
    resources:
      limits:
        cpus: '1.0'
        memory: 2G
  depends_on:
    core_prometheus:
      condition: service_healthy
    core_ollama:
      condition: service_healthy

services:
# Core Services

  # Core Portainer Service
  # Accessible at: http://localhost:9000/
  # Healthcheck status: needs work
  core_portainer:
    container_name: core_portainer
    image: portainer/portainer-ce:2.21.4
    labels:
      - "local.service.name=Core - Docker Web UI: Portainer"
      - "local.service.description=Core Portainer provides a web-based UI for managing Docker containers."
      - "local.service.source.url=https://github.com/portainer/portainer"
      - "portainer.agent.stack=true"
    restart: unless-stopped
    env_file:
      - /opt/docker/core/secrets/.portainer.env
    ports:
      - "9000:9000"
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock
      - host_core_portainer_storage_volume:/data
    deploy:
      resources:
        limits:
          cpus: '0.50'
          memory: 256M
    logging:
      <<: *default-logging
      options:
        tag: "core-management/{{.Name}}"  
    networks:
      - core_monitoring_network

  # Core Prometheus Service
  # Accessible at: http://localhost:32771
  # Healthcheck status: working
  core_prometheus:
    container_name: core_prometheus
    image: prom/prometheus:v3.0.1
    labels:
      - "local.service.name=Core - Monitoring Server: Prometheus"
      - "local.service.description=Core Prometheus monitoring server for monitoring and alerting about container services. Certain directories for this service are made available to the host machine for the purposes of data persistence."
      - "local.service.source.url=https://github.com/prometheus/prometheus"
      - "portainer.agent.stack=true"
    restart: unless-stopped
    env_file:
      - /opt/docker/core/secrets/.prometheus.env
    healthcheck:
      test: ["CMD", "wget", "--no-verbose", "--tries=1", "--spider", "http://localhost:9090/-/healthy"]
      interval: 30s
      timeout: 10s
      retries: 3
      start_period: 40s
    ports:
      - "9090"
    volumes:
      - host_core_prometheus_storage_volume:/prometheus
    deploy:
      resources:
        limits:
          cpus: '1.0'
          memory: 2G
    logging:
      <<: *default-logging
      options:
        tag: "core-monitoring/{{.Name}}"  
    networks:
      - core_monitoring_network

  # Core SearxNG Service
  # Accessible at: http://localhost:8080
  # Healthcheck status: working
  core_searxng:
    container_name: core_searxng
    image: searxng/searxng:2024.12.16-65c970bdf
    labels:
      - "local.service.name=Core - Search Engine: SearxNG"
      - "local.service.description=Core SearxNG search engine for searching the web. Certain directories for this service are made available to the host machine for the purposes of data persistence."
      - "local.service.source.url=https://github.com/searxng/searxng"
      - "portainer.agent.stack=true"
    restart: unless-stopped
    env_file:
      - /opt/docker/core/secrets/.searxng.env
    depends_on:
      core_prometheus:
        condition: service_healthy
    ports:
      - "8083:8080"
    volumes:
      - host_core_searxng_storage_volume:/etc/searxng:rw
    deploy:
      resources:
        limits:
          cpus: '0.50'
          memory: 512M
    logging:
      <<: *default-logging
      options:
        tag: "core-search/{{.Name}}"  
    networks:
      - core_monitoring_network
      - core_ai_network
      - production_db_network
      - development_db_network  


  # Core PhpMyAdmin Service
  # Accessible at: http://localhost:8082
  # Healthcheck status: working
  core_phpmyadmin:
    container_name: core_phpmyadmin
    image: phpmyadmin/phpmyadmin:5.2.1
    labels:
      - "local.service.name=CORE - DB Web UI: PHPMyAdmin"
      - "local.service.description=Core PHPMyAdmin database web ui for MariaDB. Certain directories for this service are made available to the host machine for the purposes of data persistence."
      - "local.service.source.url=https://github.com/phpmyadmin/phpmyadmin"
      - "portainer.agent.stack=true"
    restart: unless-stopped
    env_file:
      - /opt/docker/core/secrets/.phpmyadmin.env
    healthcheck:
      test: ["CMD", "curl", "-f", "http://localhost:80/"]
      interval: 30s
      timeout: 10s
      retries: 3
      start_period: 40s
    volumes:
      - host_core_phpmyadmin_storage_volume:/etc/apache2/conf-enabled
      - host_core_phpmyadmin_storage_volume:/etc/httpd
    depends_on:
      core_prometheus:
        condition: service_healthy
      production_mariadb:
        condition: service_healthy
      development_mariadb:
        condition: service_healthy
    ports:
      - "8082:80"  
    deploy:
      resources:
        limits:
          cpus: '0.50'
          memory: 512M
    logging:
      <<: *default-logging
      options:
        tag: "phpmyadmin/{{.Name}}"         
    networks:
      - core_monitoring_network
      - production_db_network
      - development_db_network

  # Core Ollama Service
  # Accessible at: http://localhost:11434
  # Healthcheck status: working
  core_ollama:
    container_name: core_ollama
    image: ollama/ollama:0.5.1
    labels:
      - "local.service.name=Core - LLM Server: Ollama"
      - "local.service.description=Core Ollama large language model inference server. This is a server which performs inference. Because more capable language models require more memory this service is being given generous memory limits."
      - "local.service.source.url=https://github.com/ollama/ollama"
      - "portainer.agent.stack=true"
    restart: unless-stopped
    env_file:
      - /opt/docker/core/secrets/.ollama.env
    healthcheck:
      test: ["CMD-SHELL", "pidof ollama || exit 1"]
      interval: 30s
      timeout: 10s
      retries: 3
      start_period: 40s
    runtime: nvidia
    deploy:
      resources:
        reservations:
          devices:
            - driver: nvidia
              device_ids: ['0', '1']
              capabilities: [gpu]
        limits:
          memory: 64G
    # https://ollama.com/library/mxbai-embed-large - ollama pull mxbai-embed-large
    # https://ollama.com/library/deepseek-coder-v2:16b - ollama pull deepseek-coder-v2:16b
    # https://ollama.com/library/qwen2.5:7b - ollama pull qwen2.5:7b
    # https://ollama.com/library/qwen2.5-coder:7b - ollama pull qwen2.5-coder:7b
    # https://ollama.com/library/qwen2.5-coder:14b - ollama pull qwen2.5-coder:14b
    # https://ollama.com/library/qwen2.5-coder:32b - ollama pull qwen2.5-coder:32b
    # https://ollama.com/library/llama3.2:3b - ollama pull llama3.2:3b
    # https://ollama.com/library/phi3.5:3.8b - ollama pull phi3.5:3.8b
    entrypoint: /bin/sh
    command: >
      -c "
      /bin/ollama serve &
      pid=$! &
      sleep 10 &
      /bin/ollama list &
      echo 'Preloading models...' &
      echo '🔴 Pulling mxbai-embed-large model...' &
      /bin/ollama pull mxbai-embed-large &
      echo '🟢 Done pulling mxbai-embed-large model!' &
      /bin/ollama list &
      echo '🔴 Pulling llama3.2:3b model...' &
      /bin/ollama pull llama3.2:3b &
      echo '🟢 Done pulling llama3.2:3b model!' &
      /bin/ollama list &      
      echo '🔴 Pulling phi3.5:3.8b model...' &
      /bin/ollama pull phi3.5:3.8b &
      echo '🟢 Done pulling phi3.5:3.8b model!' &
      /bin/ollama list &                   
      echo 'Model preloading complete.' &
      wait $pid
      "
    ports:
      - "11434:11434"
    volumes:
      - host_core_ollama_storage_volume:/root/.ollama
      - host_core_ollama_storage_volume:/data
    depends_on:
      core_prometheus:
        condition: service_healthy
    logging:
      <<: *default-logging
      options:
        tag: "core-llm-server/{{.Name}}"  
    networks:
      - core_monitoring_network      
      - core_ai_network
      - production_app_network
      - development_app_network

  # Core OpenWebUI Service
  # Accessible at: http://localhost:11435
  # Healthcheck status: working
  core_openwebui:
    container_name: core_openwebui
    image: ghcr.io/open-webui/open-webui:main
    labels:
      - "local.service.name=Core - LLM Web UI: OpenWebUI"
      - "local.service.description=Core OpenWebUI web ui for chatting with LLMs. This service must be able to communitcate with the Ollama inference server via port 11434. Certain directories for this service are made available to the host machine for the purposes of data persistence."
      - "local.service.source.url=https://github.com/open-webui/open-webui"
      - "portainer.agent.stack=true"
    restart: unless-stopped
    env_file:
      - /opt/docker/core/secrets/.openwebui.env
    healthcheck:  
      test: ["CMD-SHELL", "curl -f http://localhost:8080/auth || exit 1"]
      interval: 30s
      timeout: 10s
      retries: 3
      start_period: 40s
    ports:
      - "11435:8080"
    depends_on:
      core_prometheus:
        condition: service_healthy
      core_ollama:
        condition: service_healthy      
    deploy:
      resources:
        limits:
          cpus: '0.50'
          memory: 8192M
    logging:
      <<: *default-logging
      options:
        tag: "core-llm-ui/{{.Name}}"  
    networks:
      - core_monitoring_network
      - core_ai_network

# Production Services
  # Production PHP-fpm Apache2
  # Accessible at: http://localhost:8080
  # Healthcheck status: needs work
  production_phpfpm_apache:
    <<: *common_phpfpm_apache
    env_file:
      - /opt/docker/production/secrets/.phpfpm_apache.env
    container_name: production_phpfpm_apache  
    labels:
      - "local.service.name=Production - Web Server: PHP-fpm Apache2"
      - "local.service.description=Production PHP-fpm Apache2 web server. Certain directories for this service are made available to the host machine for the purposes of data persistence."      
      - "local.service.source.url=https://github.com/shinsenter/php"
      - "portainer.agent.stack=true"
    healthcheck:
      test: ["CMD", "curl", "-f", "http://localhost:80/"]
      interval: 30s
      timeout: 10s
      retries: 3
      start_period: 40s
    ports:
      - "8080:80"
      - "8443:443"
      - "8443:443/udp"
    #volumes:
    #  - host_production_phpfpm_apache_storage_volume:/var/www/html
    #  - host_production_phpfpm_apache_storage_volume:/usr/local/etc/php
    #  - host_production_phpfpm_apache_storage_volume:/usr/local/apache2/conf
    depends_on:
      core_prometheus:
        condition: service_healthy
    logging:
      <<: *default-logging
      options:
        tag: "production-webserver-phpfpm-apache/{{.Name}}"          
    networks:
      - core_monitoring_network
      - production_app_network      

  # Production MariaDB
  # Accessible at: http://localhost:3306
  # Healthcheck status: working
  production_mariadb:
    <<: *common_mariadb
    env_file:
      - /opt/docker/production/secrets/.mariadb.env
    container_name: production_mariadb    
    labels:
      - "local.service.name=Production - DB Server: MariaDB"
      - "local.service.description=Production MariaDB database server. Certain directories for this service are made available to the host machine for the purposes of data persistence."
      - "local.service.source.url=https://github.com/MariaDB/server"
      - "portainer.agent.stack=true"
    healthcheck:
      test: ["CMD", "mysqladmin", "ping", "-h", "localhost"]
      interval: 30s
      timeout: 10s
      retries: 3
      start_period: 40s
    ports:
      - "3306:3306"
    volumes:
      - host_production_mariadb_storage_volume:/var/lib/mysql
    depends_on:
      core_prometheus:
        condition: service_healthy
    logging:
      <<: *default-logging
      options:
        tag: "production-database-mariadb/{{.Name}}"  
    networks:
      - core_monitoring_network
      - production_app_network
      - production_db_network

  # Production Neo4j
  # Accessible at: http://localhost:7474
  # Healthcheck status: needs work
  production_neo4j:
    <<: *common_neo4j
    env_file:
      - /opt/docker/production/secrets/.neo4j.env
    container_name: production_neo4j    
    labels:
      - "local.service.name=Production - DB Server: Neo4j"
      - "local.service.description=Production Neo4j database server for knowledge graphs. The purpose of this service is to provide augment the memory of languege models with long-term memory, and enhancing of responses and recall accuracy. Certain directories for this service are made available to the host machine for the purposes of data persistence."
      - "local.service.source.url=https://github.com/neo4j/neo4j"
      - "portainer.agent.stack=true"
    ports:
      - "7474:7474"
      - "7687:7687"
    volumes:
      - host_production_neo4j_storage_volume:/data
      - host_production_neo4j_storage_volume:/logs
    depends_on:
      core_prometheus:
        condition: service_healthy
    logging:
      <<: *default-logging
      options:
        tag: "production-database/{{.Name}}"  
    networks:
      - core_monitoring_network
      - core_ai_network
      - production_app_network
      - production_db_network

# Development Services
  # Development PHP-fpm Apache2
  # Accessible at: http://localhost:8081
  # Healthcheck status: working
  development_phpfpm_apache:
    <<: *common_phpfpm_apache
    env_file:
      - /opt/docker/development/secrets/.phpfpm_apache.env
    container_name: development_phpfpm_apache  
    labels:
      - "local.service.name=Development - Web Server: PHP-fpm Apache2"
      - "local.service.description=Development web server. Certain directories for this service are made available to the host machine for the purposes of data persistence."      
      - "local.service.source.url=https://github.com/shinsenter/php"
      - "portainer.agent.stack=true"
    healthcheck:
      test: ["CMD", "curl", "-f", "http://localhost:80/"]
      interval: 30s
      timeout: 10s
      retries: 3
      start_period: 40s
    ports:
      - "8081:80"
      - "8444:443"
      - "8444:443/udp"
    #volumes:
    #  - host_development_phpfpm_apache_storage_volume:/var/www/html
    #  - host_development_phpfpm_apache_storage_volume:/usr/local/etc/php
    #  - host_development_phpfpm_apache_storage_volume:/usr/local/apache2/conf
    depends_on:
      core_prometheus:
        condition: service_healthy
    logging:
      <<: *default-logging
      options:
        tag: "development-webserver-phpfpm-apache/{{.Name}}"          
    networks:
      - core_monitoring_network
      - development_app_network

  # Development MariaDB
  # Accessible at: http://localhost:3307
  # Healthcheck status: working
  development_mariadb:
    <<: *common_mariadb
    env_file:
      - /opt/docker/development/secrets/.mariadb.env
    container_name: development_mariadb    
    labels:
      - "local.service.name=Development - DB Server: MariaDB"
      - "local.service.description=Development MariaDB database server. Certain directories for this service are made available to the host machine for the purposes of data persistence."
      - "local.service.source.url=https://github.com/MariaDB/server"
      - "portainer.agent.stack=true"
    healthcheck:
      test: ["CMD", "mysqladmin", "ping", "-h", "localhost"]
      interval: 30s
      timeout: 10s
      retries: 3
      start_period: 40s
    ports:
      - "3307:3306"
    volumes:
      - host_development_mariadb_storage_volume:/var/lib/mysql
    depends_on:
      core_prometheus:
        condition: service_healthy
    logging:
      <<: *default-logging
      options:
        tag: "development-database-mariadb/{{.Name}}"  
    networks:
      - core_monitoring_network
      - development_app_network
      - development_db_network

  # Development Neo4j
  # Accessible at: http://localhost:7475
  # Healthcheck status: needs work
  development_neo4j:
    <<: *common_neo4j
    env_file:
      - /opt/docker/development/secrets/.neo4j.env
    container_name: development_neo4j    
    labels:
      - "local.service.name=Development - DB Server: Neo4j"
      - "local.service.description=Development Neo4j database server for knowledge graphs. The purpose of this service is to provide augment the memory of languege models with long-term memory, and enhancing of responses and recall accuracy. Certain directories for this service are made available to the host machine for the purposes of data persistence."
      - "local.service.source.url=https://github.com/neo4j/neo4j"
      - "portainer.agent.stack=true"
    ports:
      - "7475:7474"
      - "7688:7687"
    volumes:
      - host_development_neo4j_storage_volume:/data
      - host_development_neo4j_storage_volume:/logs
    depends_on:
      core_prometheus:
        condition: service_healthy
    logging:
      <<: *default-logging
      options:
        tag: "development-database/{{.Name}}"  
    networks:
      - core_monitoring_network
      - core_ai_network
      - development_app_network
      - development_db_network

networks:
# Core Networks
  # Core Monitoring Network is used to monitor all of our services/docker containers ( Prometheus and Portainer )
  core_monitoring_network:
    driver: bridge
  # Core Remote Access Network is used for our remote access related services/docker containers ( Zrok )
  core_remote_access_network:
    driver: bridge
  # Core AI Network is used for our AI related services/docker containers ( Ollama, TGI, and OpenWebUI )
  core_ai_network:
    driver: bridge

# Production Networks
  # Production App Network is used for our web application related services/docker containers ( Apache2, PHP, MariaDB, Neo4j, Ollama, TGI )
  production_app_network:
    driver: bridge
  # Production DB Network is used for our database related services/docker containers ( MariaDB, Neo4j, PHPMyAdmin )
  production_db_network:
    driver: bridge

# Development Networks
  # Development App Network is used for our web application related services/docker containers ( Apache2, PHP, MariaDB, Neo4j, Ollama, TGI )
  development_app_network:
    driver: bridge
  # Development DB Network is used for our database related services/docker containers ( MariaDB, Neo4j, PHPMyAdmin )
  development_db_network:
    driver: bridge      
EOF

  log "Docker configurations created successfully."
}

# Cleanup function
cleanup() {
    log "Cleaning up..."
    # Add any cleanup tasks here if needed
    exit 0
}

# Set up trap for cleanup
trap cleanup EXIT

# Main execution
log "Starting Docker WebDev Project Setup"
#check_dependencies
#install_nvidia_toolkit
create_project_structure
generate_secrets
create_docker_configs

log "Project setup complete!"
log "To start the project, run: docker-compose up -d --build"
