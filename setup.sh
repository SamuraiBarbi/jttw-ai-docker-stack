#!/bin/bash

# Color codes for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

HOST_USER_UID=$(id -u $USER)
HOST_USER_GID=$(id -g $USER)
WWW_DATA_USER_UID=$(id -u www-data)
WWW_DATA_USER_GID=$(id -g www-data)

# Define essential path variables
BASE_PATH="$HOME/.docker"
CORE_PATH="$BASE_PATH/core"
PRODUCTION_PATH="$BASE_PATH/production"
DEVELOPMENT_PATH="$BASE_PATH/development"

# Define secrets path variables
CORE_SECRETS_PATH="$CORE_PATH/secrets"
PRODUCTION_SECRETS_PATH="$PRODUCTION_PATH/secrets"
DEVELOPMENT_SECRETS_PATH="$DEVELOPMENT_PATH/secrets"

# Define data path variables
CORE_DATA_PATH="$CORE_PATH/data"
PRODUCTION_DATA_PATH="$PRODUCTION_PATH/data"
DEVELOPMENT_DATA_PATH="$DEVELOPMENT_PATH/data"

# Define core service data path and environment file variables
CORE_PORTAINER_DATA_PATH="$CORE_DATA_PATH/portainer"
CORE_PORTAINER_ENVIRONMENT_FILE="$CORE_SECRETS_PATH/.portainer.env"

CORE_PROMETHEUS_DATA_PATH="$CORE_DATA_PATH/prometheus"
CORE_PROMETHEUS_ENVIRONMENT_FILE="$CORE_SECRETS_PATH/.prometheus.env"

CORE_SEARXNG_DATA_PATH="$CORE_DATA_PATH/searxng"
CORE_SEARXNG_ENVIRONMENT_FILE="$CORE_SECRETS_PATH/.searxng.env"

CORE_PHPMYADMIN_DATA_PATH="$CORE_DATA_PATH/phpmyadmin"
CORE_PHPMYADMIN_ENVIRONMENT_FILE="$CORE_SECRETS_PATH/.phpmyadmin.env"

CORE_OLLAMA_DATA_PATH="$CORE_DATA_PATH/ollama"
CORE_OLLAMA_ENVIRONMENT_FILE="$CORE_SECRETS_PATH/.ollama.env"

CORE_OPENWEBUI_DATA_PATH="$CORE_DATA_PATH/openwebui"
CORE_OPENWEBUI_ENVIRONMENT_FILE="$CORE_SECRETS_PATH/.openwebui.env"

# Define production service data path and environment file variables
PRODUCTION_PHPFPM_APACHE_DATA_PATH="$PRODUCTION_DATA_PATH/phpfpm_apache"
PRODUCTION_PHPFPM_APACHE_ENVIRONMENT_FILE="$PRODUCTION_SECRETS_PATH/.phpfpm_apache.env" 

PRODUCTION_MARIADB_DATA_PATH="$PRODUCTION_DATA_PATH/mariadb"
PRODUCTION_MARIADB_ENVIRONMENT_FILE="$PRODUCTION_SECRETS_PATH/.mariadb.env"

PRODUCTION_NEO4J_DATA_PATH="$PRODUCTION_DATA_PATH/neo4j"
PRODUCTION_NEO4J_ENVIRONMENT_FILE="$PRODUCTION_SECRETS_PATH/.neo4j.env"

# Define development service data path and environment file variables
DEVELOPMENT_PHPFPM_APACHE_DATA_PATH="$DEVELOPMENT_DATA_PATH/phpfpm_apache"
DEVELOPMENT_PHPFPM_APACHE_ENVIRONMENT_FILE="$DEVELOPMENT_SECRETS_PATH/.phpfpm_apache.env"

DEVELOPMENT_MARIADB_DATA_PATH="$DEVELOPMENT_DATA_PATH/mariadb"
DEVELOPMENT_MARIADB_ENVIRONMENT_FILE="$DEVELOPMENT_SECRETS_PATH/.mariadb.env"

DEVELOPMENT_NEO4J_DATA_PATH="$DEVELOPMENT_DATA_PATH/neo4j"
DEVELOPMENT_NEO4J_ENVIRONMENT_FILE="$DEVELOPMENT_SECRETS_PATH/.neo4j.env"


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
  sudo mkdir -p $BASE_PATH || error "Failed to create base directory."
  sudo chown -R $USER:$USER $BASE_PATH || error "Failed to set ownership for $BASE_PATH."

  sudo -u $USER mkdir -p $BASE_PATH/{core,production,development}/{data,secrets} || error "Failed to create base directories."

  # Create core service directories
  sudo -u $USER mkdir -p $CORE_DATA_PATH/{portainer,prometheus,searxng,phpmyadmin,ollama,openwebui} || error "Failed to create core service directories."

  # Create production service directories
  sudo -u $USER mkdir -p $PRODUCTION_DATA_PATH/{phpfpm_apache,mariadb,neo4j} || error "Failed to create production service directories."
  sudo -u $USER mkdir -p $PRODUCTION_PHPFPM_APACHE_DATA_PATH/{config_php,config_apache,data_apache} || error "Failed to create production PHP-fpm Apache directories."
  sudo -u $USER mkdir -p $PRODUCTION_MARIADB_DATA_PATH/data_mysql || error "Failed to create production MariaDB directories."
  sudo -u $USER mkdir -p $PRODUCTION_NEO4J_DATA_PATH/{data,logs} || error "Failed to create production Neo4j directories."
  # Create development service directories
  sudo -u $USER mkdir -p $DEVELOPMENT_DATA_PATH/{phpfpm_apache,mariadb,neo4j} || error "Failed to create development service directories."
  sudo -u $USER mkdir -p $DEVELOPMENT_PHPFPM_APACHE_DATA_PATH/{config_php,config_apache,data_apache} || error "Failed to create development PHP-fpm Apache directories."
  sudo -u $USER mkdir -p $DEVELOPMENT_MARIADB_DATA_PATH/data_mysql || error "Failed to create development MariaDB directories."
  sudo -u $USER mkdir -p $DEVELOPMENT_NEO4J_DATA_PATH/{data,logs} || error "Failed to create development Neo4j directories."
  # Set permissions
  sudo -u $USER chmod -R 755 $BASE_PATH || error "Failed to set permissions for $BASE_PATH."

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
  if [ ! -f "$CORE_SECRETS_PATH/.portainer.env" ]; then
    sudo -u $USER touch $CORE_SECRETS_PATH/.portainer.env || error "Failed to create core .portainer.env."
    echo "PORTAINER_ADMIN_PASSWORD=$(generate_random_string)" > $CORE_SECRETS_PATH/.portainer.env || error "Failed to write PORTAINER_ADMIN_PASSWORD to core .portainer.env."
  fi

  if [ ! -f "$CORE_SECRETS_PATH/.prometheus.env" ]; then
    sudo -u $USER touch $CORE_SECRETS_PATH/.prometheus.env || error "Failed to create core .prometheus.env."
    echo "PROMETHEUS_PASSWORD=$(generate_random_string)" > $CORE_SECRETS_PATH/.prometheus.env || error "Failed to write PROMETHEUS_PASSWORD to core .prometheus.env."
  fi

  if [ ! -f "$CORE_SECRETS_PATH/.searxng.env" ]; then
    sudo -u $USER touch $CORE_SECRETS_PATH/.searxng.env || error "Failed to create core .searxng.env."
    echo "SEARXNG_BASE_URL=http://localhost:8083" > $CORE_SECRETS_PATH/.searxng.env || error "Failed to write BASE_URL to core .searxng.env."
    echo "INSTANCE_NAME=JTTW SearxNG" >> $CORE_SECRETS_PATH/.searxng.env || error "Failed to write INSTANCE_NAME to core .searxng.env."
    echo "UWSGI_WORKERS=4" >> $CORE_SECRETS_PATH/.searxng.env || error "Failed to write UWSGI_WORKERS to core .searxng.env."
    echo "UWSGI_THREADS=4" >> $CORE_SECRETS_PATH/.searxng.env || error "Failed to write UWSGI_THREADS to core .searxng.env."
    echo "SEARXNG_SEARCH_FORMATS=html,json" >> $CORE_SECRETS_PATH/.searxng.env || error "Failed to write SEARXNG_SETTINGS_SEARCH__FORMATS to core .searxng.env."
    echo "SEARXNG_SEARCH_DEFAULT_FORMAT=html" >> $CORE_SECRETS_PATH/.searxng.env || error "Failed to write SEARXNG_SETTINGS_SEARCH__DEFAULT_FORMAT to core .searxng.env."
  fi

  if [ ! -f "$CORE_SECRETS_PATH/.phpmyadmin.env" ]; then    
    sudo -u $USER touch $CORE_SECRETS_PATH/.phpmyadmin.env || error "Failed to create core .phpmyadmin.env."
    echo "PMA_HOSTS=production_mariadb,development_mariadb" > $CORE_SECRETS_PATH/.phpmyadmin.env || error "Failed to write PMA_HOSTS to core .phpmyadmin.env."
    echo "PMA_PORTS=3306,3306" >> $CORE_SECRETS_PATH/.phpmyadmin.env || error "Failed to write PMA_PORTS to core .phpmyadmin.env."    
    # echo "PMA_PMADB=development_mariadb" >> $CORE_SECRETS_PATH/.phpmyadmin.env || error "Failed to write PMA_PMADB to core .phpmyadmin.env."
    # echo "PMA_CONTROLUSER=pma" >> $CORE_SECRETS_PATH/.phpmyadmin.env || error "Failed to write PMA_CONTROLUSER to core .phpmyadmin.env."
    # echo "PMA_CONTROLPASS=$(generate_random_string)" >> $CORE_SECRETS_PATH/.phpmyadmin.env || error "Failed to write PMA_CONTROLPASS to core .phpmyadmin.env."
  fi

  if [ ! -f "$CORE_SECRETS_PATH/.ollama.env" ]; then
    sudo -u $USER touch $CORE_SECRETS_PATH/.ollama.env || error "Failed to create core .ollama.env."
    echo "OLLAMA_FLASH_ATTENTION=1" > $CORE_SECRETS_PATH/.ollama.env || error "Failed to write OLLAMA_FLASH_ATTENTION to core .ollama.env."
    echo "OLLAMA_API_BASE_URL=http://127.0.0.1:11434" >> $CORE_SECRETS_PATH/.ollama.env || error "Failed to write OLLAMA_BASE_URL to core .ollama.env."
    echo "OLLAMA_HOST=0.0.0.0" >> $CORE_SECRETS_PATH/.ollama.env || error "Failed to write OLLAMA_HOST to core .ollama.env."
  fi

  if [ ! -f "$CORE_SECRETS_PATH/.openwebui.env" ]; then
    sudo -u $USER touch $CORE_SECRETS_PATH/.openwebui.env || error "Failed to create core .openwebui.env."
    echo "WEBUI_SECRET_KEY=$(generate_random_string)" >> $CORE_SECRETS_PATH/.openwebui.env || error "Failed to write WEBUI_SECRET_KEY to core .openwebui.env."    
    echo "OLLAMA_BASE_URLS=http://core_ollama:11434" > $CORE_SECRETS_PATH/.openwebui.env || error "Failed to write OLLAMA_BASE_URLS to core .openwebui.env."
    echo "RAG_EMBEDDING_ENGINE=ollama" >> $CORE_SECRETS_PATH/.openwebui.env || error "Failed to write RAG_EMBEDDING_ENGINE to core .openwebui.env."
    echo "RAG_OLLAMA_BASE_URL=http://core_ollama:11434" >> $CORE_SECRETS_PATH/.openwebui.env || error "Failed to write RAG_OPENAI_API_BASE_URL to core .openwebui.env."
    echo "RAG_EMBEDDING_MODEL=mxbai-embed-large" >> $CORE_SECRETS_PATH/.openwebui.env || error "Failed to write RAG_EMBEDDING_MODEL to core .openwebui.env."
    echo "ENABLE_RAG_WEB_SEARCH=True" >> $CORE_SECRETS_PATH/.openwebui.env || error "Failed to write ENABLE_RAG_WEB_SEARCH to core .openwebui.env."
    echo "ENABLE_SEARCH_QUERY=True" >> $CORE_SECRETS_PATH/.openwebui.env || error "Failed to write ENABLE_SEARCH_QUERY to core .openwebui.env."
    # echo "RAG_WEB_SEARCH_ENGINE=duckduckgo" >> $CORE_SECRETS_PATH/.openwebui.env || error "Failed to write RAG_WEB_SEARCH_ENGINE to core .openwebui.env."
    # To enable searxng searching, we need to uncomments the following lines and edit the searxng $CORE_SEARXNG_DATA_PATH/searxng/settings.yml file to add json to formats:
    echo "RAG_WEB_SEARCH_ENGINE=searxng" >> $CORE_SECRETS_PATH/.openwebui.env || error "Failed to write RAG_WEB_SEARCH_ENGINE to core .openwebui.env."
    echo "SEARXNG_QUERY_URL=http://core_searxng:8080/search?q=<query>&format=json" >> $CORE_SECRETS_PATH/.openwebui.env || error "Failed to write SEARXNG_QUERY_URL to core .openwebui.env."
    echo "RAG_WEB_SEARCH_RESULT_COUNT=5" >> $CORE_SECRETS_PATH/.openwebui.env || error "Failed to write RAG_WEB_SEARCH_RESULT_COUNT to core .openwebui.env."
    echo "RAG_WEB_SEARCH_CONCURRENT_REQUESTS=10" >> $CORE_SECRETS_PATH/.openwebui.env || error "Failed to write RAG_WEB_SEARCH_CONCURRENT_REQUESTS to core .openwebui.env."
  fi


  # Production secrets
  if [ ! -f "$PRODUCTION_SECRETS_PATH/.mariadb.env" ]; then
    sudo -u $USER touch $PRODUCTION_SECRETS_PATH/.mariadb.env || error "Failed to create production .mariadb.env."
    echo "MARIADB_ROOT_PASSWORD=$(generate_random_string)" > $PRODUCTION_SECRETS_PATH/.mariadb.env || error "Failed to write MARIADB_ROOT_PASSWORD to production .mariadb.env."
    echo "MARIADB_DATABASE=production" >> $PRODUCTION_SECRETS_PATH/.mariadb.env || error "Failed to write MARIADB_DATABASE to production .mariadb.env."
    echo "MARIADB_USER=production_user" >> $PRODUCTION_SECRETS_PATH/.mariadb.env || error "Failed to write MARIADB_USER to production .mariadb.env."
    echo "MARIADB_PASSWORD=$(generate_random_string)" >> $PRODUCTION_SECRETS_PATH/.mariadb.env || error "Failed to write MARIADB_PASSWORD to production .mariadb.env."
  fi

  if [ ! -f "$PRODUCTION_SECRETS_PATH/.neo4j.env" ]; then
    sudo -u $USER touch $PRODUCTION_SECRETS_PATH/.neo4j.env || error "Failed to create production .neo4j.env."
    echo "NEO4J_AUTH=neo4j/$(generate_random_string)" > $PRODUCTION_SECRETS_PATH/.neo4j.env || error "Failed to write NEO4J_AUTH to production .neo4j.env."    
  fi

  if [ ! -f "$PRODUCTION_SECRETS_PATH/.phpfpm_apache.env" ]; then
    sudo -u $USER touch $PRODUCTION_SECRETS_PATH/.phpfpm_apache.env || error "Failed to create production .phpfpm_apache.env."
    echo "PHP_FPM_PASSWORD=$(generate_random_string)" > $PRODUCTION_SECRETS_PATH/.phpfpm_apache.env || error "Failed to write PHP_FPM_PASSWORD to production .phpfpm_apache.env."
    echo "APACHE2_PASSWORD=$(generate_random_string)" >> $PRODUCTION_SECRETS_PATH/.phpfpm_apache.env || error "Failed to write APACHE2_PASSWORD to production .phpfpm_apache.env." 
    
  fi

  # Development secrets
  if [ ! -f "$DEVELOPMENT_SECRETS_PATH/.mariadb.env" ]; then
    sudo -u $USER touch $DEVELOPMENT_SECRETS_PATH/.mariadb.env || error "Failed to create development .mariadb.env."
    echo "MARIADB_ROOT_PASSWORD=$(generate_random_string)" > $DEVELOPMENT_SECRETS_PATH/.mariadb.env || error "Failed to write MARIADB_ROOT_PASSWORD to development .mariadb.env."
    echo "MARIADB_DATABASE=development" >> $DEVELOPMENT_SECRETS_PATH/.mariadb.env || error "Failed to write MARIADB_DATABASE to development .mariadb.env."
    echo "MARIADB_USER=development_user" >> $DEVELOPMENT_SECRETS_PATH/.mariadb.env || error "Failed to write MARIADB_USER to development .mariadb.env."
    echo "MARIADB_PASSWORD=$(generate_random_string)" >> $DEVELOPMENT_SECRETS_PATH/.mariadb.env || error "Failed to write MARIADB_PASSWORD to development .mariadb.env."
  fi

  if [ ! -f "$DEVELOPMENT_SECRETS_PATH/.neo4j.env" ]; then
    sudo -u $USER touch $DEVELOPMENT_SECRETS_PATH/.neo4j.env || error "Failed to create development.neo4j.env."
    echo "NEO4J_AUTH=neo4j/$(generate_random_string)" > $DEVELOPMENT_SECRETS_PATH/.neo4j.env || error "Failed to write NEO4J_AUTH to development .neo4j.env."
  fi

  if [ ! -f "$DEVELOPMENT_SECRETS_PATH/.phpfpm_apache.env" ]; then
    sudo -u $USER touch $DEVELOPMENT_SECRETS_PATH/.phpfpm_apache.env || error "Failed to create development .phpfpm_apache.env."
    echo "PHP_FPM_PASSWORD=$(generate_random_string)" > $DEVELOPMENT_SECRETS_PATH/.phpfpm_apache.env || error "Failed to write PHP_FPM_PASSWORD to development .phpfpm_apache.env."
    echo "APACHE2_PASSWORD=$(generate_random_string)" >> $DEVELOPMENT_SECRETS_PATH/.phpfpm_apache.env || error "Failed to write APACHE2_PASSWORD to development .phpfpm_apache.env."
      
  fi

  # Set specific permissions for secrets directories
  # sudo -u $USER chmod -R 700 $BASE_PATH/*/secrets/ || error "Failed to set permissions for secrets directories."

  log "Secrets generated and stored successfully"
}

# Create Docker configuration files
create_docker_configs() {
  log "Creating Docker configuration files..."

  cat > docker-compose.yml << EOF
# sudo -S docker compose down --remove-orphans
# sudo -S docker system prune -af
# sudo -S docker ps -a && echo '=== Images ===' && echo darkness | sudo -S docker images && echo '=== Networks ===' && echo darkness | sudo -S docker network ls
# sudo rm -rf $BASE_PATH/*
# cd /mnt/d/backup/local_files/Documents/WSL && bash docker-setup-script-v1.1.sh
# cd /mnt/d/backup/local_files/Documents/WSL && sudo -S docker compose up -d
# docker logs production_mariadb
# docker exec core_ollama ollama list
# ollama pull hf.co/unsloth/Qwen2.5-Coder-32B-Instruct-128K-GGUF:Q4_K_M
volumes:
# Core volumes
  host_core_storage_volume:
    driver: local
    driver_opts:
      type: none
      device: $CORE_PATH/
      o: bind    
  host_core_secrets_volume:
    driver: local
    driver_opts:
      type: none
      device: $CORE_SECRETS_PATH/
      o: bind
  host_core_portainer_storage_volume:
    driver: local
    driver_opts:
      type: none
      device: $CORE_PORTAINER_DATA_PATH/
      o: bind
  host_core_prometheus_storage_volume:
    driver: local
    driver_opts:
      type: none
      device: $CORE_PROMETHEUS_DATA_PATH/
      o: bind      
  host_core_searxng_storage_volume:
    driver: local
    driver_opts:
      type: none
      device: $CORE_SEARXNG_DATA_PATH/
      o: bind
      create: "true"
  host_core_phpmyadmin_storage_volume:
    driver: local
    driver_opts:
      type: none
      device: $CORE_PHPMYADMIN_DATA_PATH/
      o: bind
  host_core_ollama_storage_volume:
    driver: local
    driver_opts:
      type: none
      device: $CORE_OLLAMA_DATA_PATH/
      o: bind
  host_core_openwebui_storage_volume:
    driver: local
    driver_opts:
      type: none
      device: $CORE_OPENWEBUI_DATA_PATH/
      o: bind          
      
# Production volumes
  host_production_secrets_volume:
    driver: local
    driver_opts:
      type: none
      device: $PRODUCTION_SECRETS_PATH/
      o: bind   
  host_production_phpfpm_apache_data_apache_volume:
    driver: local
    driver_opts:
      type: none
      device: $PRODUCTION_PHPFPM_APACHE_DATA_PATH/data_apache/
      o: bind
  host_production_phpfpm_apache_config_php_volume:
    driver: local
    driver_opts:
      type: none
      device: $PRODUCTION_PHPFPM_APACHE_DATA_PATH/config_php/
      o: bind    
  host_production_phpfpm_apache_config_apache_volume:
    driver: local
    driver_opts:
      type: none
      device: $PRODUCTION_PHPFPM_APACHE_DATA_PATH/config_apache/
      o: bind       
  host_production_mariadb_data_mysql_volume:
    driver: local
    driver_opts:
      type: none
      device: $PRODUCTION_MARIADB_DATA_PATH/data_mysql/
      o: bind
  host_production_neo4j_data_volume:
    driver: local
    driver_opts:
      type: none
      device: $PRODUCTION_NEO4J_DATA_PATH/data/
      o: bind
  host_production_neo4j_logs_volume:
    driver: local
    driver_opts:
      type: none
      device: $PRODUCTION_NEO4J_DATA_PATH/logs/
      o: bind

# Development volumes
  host_development_secrets_volume:
    driver: local
    driver_opts:
      type: none
      device: $DEVELOPMENT_SECRETS_PATH/
      o: bind 
  host_development_phpfpm_apache_data_apache_volume:
    driver: local
    driver_opts:
      type: none
      device: $DEVELOPMENT_PHPFPM_APACHE_DATA_PATH/data_apache/
      o: bind
  host_development_phpfpm_apache_config_php_volume:
    driver: local
    driver_opts:
      type: none
      device: $DEVELOPMENT_PHPFPM_APACHE_DATA_PATH/config_php/
      o: bind    
  host_development_phpfpm_apache_config_apache_volume:
    driver: local
    driver_opts:
      type: none
      device: $DEVELOPMENT_PHPFPM_APACHE_DATA_PATH/config_apache/
      o: bind    
  host_development_mariadb_data_mysql_volume:
    driver: local
    driver_opts:
      type: none
      device: $DEVELOPMENT_MARIADB_DATA_PATH/data_mysql/
      o: bind
  host_development_neo4j_data_volume:
    driver: local
    driver_opts:
      type: none
      device: $DEVELOPMENT_NEO4J_DATA_PATH/data/
      o: bind
  host_development_neo4j_logs_volume:
    driver: local
    driver_opts:
      type: none
      device: $DEVELOPMENT_NEO4J_DATA_PATH/logs/
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
  depends_on:
    core_prometheus:
      condition: service_healthy  
  deploy:
    resources:
      limits:
        cpus: '0.50'
        memory: 512M

x-common_mariadb: &common_mariadb        
  image: mariadb:10.6
  restart: unless-stopped
  depends_on:
    core_prometheus:
      condition: service_healthy  
  deploy:
    resources:
      limits:
        cpus: '1.0'
        memory: 1G

x-common_neo4j: &common_neo4j
  image: neo4j:5.7.0-community
  restart: unless-stopped
  user: "${HOST_USER_UID}:${HOST_USER_GID}"
  depends_on:
    core_prometheus:
      condition: service_healthy
    core_ollama:
      condition: service_healthy    
  deploy:
    resources:
      limits:
        cpus: '1.0'
        memory: 2G


services:
# Core Services

  # Core Portainer Service
  # Accessible at: http://localhost:9000/
  # Healthcheck status: not sure how to healthcheck Portainer because it lacks bash and shell. http://core_portainer:9000/api/system/status would be the best
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
      - $CORE_PORTAINER_ENVIRONMENT_FILE
    ports:
      - "9000:9000"
    deploy:
      resources:
        limits:
          cpus: '0.50'
          memory: 256M
    logging:
      <<: *default-logging
      options:
        tag: "core-management/{{.Name}}"  
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock
      - host_core_portainer_storage_volume:/data
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
      - $CORE_PROMETHEUS_ENVIRONMENT_FILE
    ports:
      - "9090:9090"
    healthcheck:
      test: ["CMD", "wget", "--no-verbose", "--tries=1", "--spider", "http://core_prometheus:9090/-/healthy"]
      interval: 30s
      timeout: 10s
      retries: 3
      start_period: 40s
    deploy:
      resources:
        limits:
          cpus: '1.0'
          memory: 2G
    logging:
      <<: *default-logging
      options:
        tag: "core-monitoring/{{.Name}}"  
    volumes:
      - host_core_prometheus_storage_volume:/prometheus
    networks:
      - core_monitoring_network

  # Core SearxNG Service
  # Accessible at: http://localhost:8080
  # Healthcheck status: working
  core_searxng:
    container_name: core_searxng
    image: searxng/searxng:2024.12.16-65c970bdf
    restart: unless-stopped
    user: "${HOST_USER_UID}:${HOST_USER_GID}"
    labels:
      - "local.service.name=Core - Search Engine: SearxNG"
      - "local.service.description=Core SearxNG search engine for searching the web. Certain directories for this service are made available to the host machine for the purposes of data persistence."
      - "local.service.source.url=https://github.com/searxng/searxng"
      - "portainer.agent.stack=true"  
    env_file:
      - $CORE_SEARXNG_ENVIRONMENT_FILE     
    ports:
      - "8083:8080" 
    healthcheck:
      test: ["CMD", "wget", "--no-verbose", "--tries=1", "--spider", "http://core_searxng:8080/"]
      interval: 30s
      timeout: 10s
      retries: 5
      start_period: 40s
    depends_on:
      core_prometheus:
        condition: service_healthy
    entrypoint: /bin/sh
    command: |
      -c '
      # Start searxng first to create settings.yml
      /usr/local/searxng/dockerfiles/docker-entrypoint.sh &
      
      # Wait for settings file to exist
      while [ ! -f "/etc/searxng/settings.yml" ]; do
        echo "Waiting for settings.yml to be created..."
        sleep 2
      done
      
      # Give it a moment to finish writing
      sleep 2
      
      # Check if json format is in the file
      if ! grep -q "^    - json" "/etc/searxng/settings.yml"; then
        echo "Adding json format to settings.yml..."
        # If formats section exists, append json to it
        if grep -q "^  formats:" "/etc/searxng/settings.yml"; then
          sed -i "/^  formats:/a\\    - json" "/etc/searxng/settings.yml"
        else
          # If formats section doesnt exist, add it with proper YAML formatting
          echo "  formats:" >> "/etc/searxng/settings.yml"
          echo "    - html" >> "/etc/searxng/settings.yml"
          echo "    - json" >> "/etc/searxng/settings.yml"
        fi
        echo "Successfully added json format"
        
        # Restart the service to apply changes
        echo "Restarting searxng to apply changes..."
        killall -s SIGTERM uwsgi
        sleep 2
        exec /usr/local/searxng/dockerfiles/docker-entrypoint.sh
      else
        echo "json format already exists in settings.yml"
        # Keep the container running
        wait
      fi'
    deploy:
      resources:
        limits:
          cpus: '0.50'
          memory: 512M
    logging:
      <<: *default-logging
      options:
        tag: "core-search/{{.Name}}" 
    volumes:
      - host_core_searxng_storage_volume:/etc/searxng:rw         
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
    restart: unless-stopped
    labels:
      - "local.service.name=CORE - DB Web UI: PHPMyAdmin"
      - "local.service.description=Core PHPMyAdmin database web ui for MariaDB. Certain directories for this service are made available to the host machine for the purposes of data persistence."
      - "local.service.source.url=https://github.com/phpmyadmin/phpmyadmin"
      - "portainer.agent.stack=true"    
    env_file:
      - $CORE_PHPMYADMIN_ENVIRONMENT_FILE
    ports:
      - "8082:80"  
    healthcheck:
      test: ["CMD", "curl", "-f", "http://core_phpmyadmin:80/"]
      interval: 30s
      timeout: 10s
      retries: 3
      start_period: 40s
    depends_on:
      core_prometheus:
        condition: service_healthy
      production_mariadb:
        condition: service_healthy
      development_mariadb:
        condition: service_healthy
    deploy:
      resources:
        limits:
          cpus: '0.50'
          memory: 512M
    logging:
      <<: *default-logging
      options:
        tag: "phpmyadmin/{{.Name}}"    
    volumes:
      - host_core_phpmyadmin_storage_volume:/etc/apache2/conf-enabled
      - host_core_phpmyadmin_storage_volume:/etc/httpd             
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
    restart: unless-stopped
    labels:
      - "local.service.name=Core - LLM Server: Ollama"
      - "local.service.description=Core Ollama large language model inference server. This is a server which performs inference. Because more capable language models require more memory this service is being given generous memory limits."
      - "local.service.source.url=https://github.com/ollama/ollama"
      - "portainer.agent.stack=true"
    env_file:
      - $CORE_OLLAMA_ENVIRONMENT_FILE
    ports:
      - "11434:11434"      
    healthcheck:
      test: ["CMD-SHELL", "curl -f http://core_ollama:11434/api/version || exit 1"]
      interval: 30s
      timeout: 10s
      retries: 3
      start_period: 40s      
    entrypoint: /bin/sh
    command: |
      -c '
      # Define all functions
      check_server() {
        curl -s http://core_ollama:11434/api/version >/dev/null 2>&1
      }
      
      wait_for_server() {
        max_attempts=30
        attempt=1
        echo "Waiting for Ollama server to be ready..."
        while [ $attempt -le $max_attempts ]; do
          if check_server; then
            echo "Ollama server is ready!"
            return 0
          fi
          echo "Attempt $attempt/$max_attempts: Server not ready, waiting..."
          sleep 10
          attempt=$((attempt + 1))
        done
        echo "Failed to connect to Ollama server after multiple attempts"
        return 1
      }
      
      download_model() {
        local model="$1"
        local max_retries=3
        local retry=1
        
        while [ $retry -le $max_retries ]; do
          echo "Downloading model '"$model"' (attempt $retry/$max_retries)..."
          if /bin/ollama pull "$model"; then
            echo "Successfully downloaded model '"$model"'"
            return 0
          fi
          echo "Failed to download model '"$model"' on attempt $retry"
          retry=$((retry + 1))
          [ $retry -le $max_retries ] && sleep 5
        done
        return 1
      }
      
      echo "Starting Ollama server..."
      
      # Install required packages quietly
      if ! command -v curl >/dev/null || ! command -v nc >/dev/null; then
        apt-get update -qq && apt-get install -qq -y curl netcat-traditional >/dev/null 2>&1
      fi
            
      # Start the server
      /bin/ollama serve &
      server_pid=$!
      
      # Wait for server to be ready
      if ! wait_for_server; then
        echo "Server failed to start"
        exit 1
      fi
      
      # Download models sequentially with error handling
      echo "Starting model downloads..."
      download_errors=0
      
      # Test ollama command
      echo "Testing ollama command..."
      /bin/ollama --version
      
      # Download models one by one
      echo "Downloading mxbai-embed-large..."
      if ! /bin/ollama pull mxbai-embed-large; then
        echo "Failed to download mxbai-embed-large"
        download_errors=$((download_errors + 1))
      fi
      
      echo "Downloading llama3.2:3b..."
      if ! /bin/ollama pull llama3.2:3b; then
        echo "Failed to download llama3.2:3b"
        download_errors=$((download_errors + 1))
      fi
      
      echo "Downloading phi3.5:3.8b..."
      if ! /bin/ollama pull phi3.5:3.8b; then
        echo "Failed to download phi3.5:3.8b"
        download_errors=$((download_errors + 1))
      fi

      echo "Downloading qwen2.5:14b..."
      if ! /bin/ollama pull qwen2.5:14b; then
        echo "Failed to download qwen2.5:14b"
        download_errors=$((download_errors + 1))
      fi      

      echo "Downloading hhao/qwen2.5-coder-tools:32b..."
      if ! /bin/ollama pull hhao/qwen2.5-coder-tools:32b; then
        echo "Failed to download hhao/qwen2.5-coder-tools:32b"
        download_errors=$((download_errors + 1))
      fi      

      # Report final status
      if [ "$download_errors" = "0" ]; then
        echo "All models downloaded successfully!"
      else
        echo "Warning: $download_errors model(s) failed to download"
      fi
      
      # Keep container running
      wait $server_pid'
    depends_on:
      core_prometheus:
        condition: service_healthy
    runtime: nvidia
    deploy:
      resources:
        reservations:
          devices:
            - driver: nvidia
              count: all
              capabilities: [gpu]
        limits:
          memory: 64G
    logging:
      <<: *default-logging
      options:
        tag: "core-llm-server/{{.Name}}" 
    volumes:
      - host_core_ollama_storage_volume:/root/.ollama
      - host_core_ollama_storage_volume:/data        
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
      - $CORE_OPENWEBUI_ENVIRONMENT_FILE
    ports:
      - "11435:8080"
    healthcheck:  
      test: ["CMD-SHELL", "curl -f http://core_openwebui:8080/auth || exit 1"]
      interval: 30s
      timeout: 10s
      retries: 3
      start_period: 40s
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
  # Healthcheck status: working
  production_phpfpm_apache:
    container_name: production_phpfpm_apache  
    labels:
      - "local.service.name=Production - Web Server: PHP-fpm Apache2"
      - "local.service.description=Production PHP-fpm Apache2 web server. Certain directories for this service are made available to the host machine for the purposes of data persistence."      
      - "local.service.source.url=https://github.com/shinsenter/php"
      - "portainer.agent.stack=true"  
    <<: *common_phpfpm_apache
    env_file:
      - $PRODUCTION_PHPFPM_APACHE_ENVIRONMENT_FILE
    ports:
      - "8080:80"
      - "8443:443"
      - "8443:443/udp"
    healthcheck:
      test: ["CMD", "curl", "-f", "http://production_phpfpm_apache:80/"]
      interval: 30s
      timeout: 10s
      retries: 3
      start_period: 40s
    logging:
      <<: *default-logging
      options:
        tag: "production-webserver-phpfpm-apache/{{.Name}}"   
    volumes:
      - host_production_phpfpm_apache_data_apache_volume:/var/www/html
      - host_production_phpfpm_apache_config_php_volume:/usr/local/etc/php
      - host_production_phpfpm_apache_config_apache_volume:/usr/local/apache2/conf       
    networks:
      - core_monitoring_network
      - production_app_network      

  # Production MariaDB
  # Accessible at: http://localhost:3306
  # Healthcheck status: working
  production_mariadb:
    container_name: production_mariadb    
    labels:
      - "local.service.name=Production - DB Server: MariaDB"
      - "local.service.description=Production MariaDB database server. Certain directories for this service are made available to the host machine for the purposes of data persistence."
      - "local.service.source.url=https://github.com/MariaDB/server"
      - "portainer.agent.stack=true"  
    <<: *common_mariadb
    env_file:
      - $PRODUCTION_MARIADB_ENVIRONMENT_FILE
    ports:
      - "3306:3306"
    healthcheck:
      test: ["CMD", "mysqladmin", "ping", "-h", "production_mariadb"]
      interval: 30s
      timeout: 10s
      retries: 3
      start_period: 40s
    logging:
      <<: *default-logging
      options:
        tag: "production-database-mariadb/{{.Name}}"
    volumes:
      - host_production_mariadb_data_mysql_volume:/var/lib/mysql
    networks:
      - core_monitoring_network
      - production_app_network
      - production_db_network

  # Production Neo4j
  # Accessible at: http://localhost:7474
  # Healthcheck status: working
  production_neo4j:
    container_name: production_neo4j    
    labels:
      - "local.service.name=Production - DB Server: Neo4j"
      - "local.service.description=Production Neo4j database server for knowledge graphs. The purpose of this service is to provide augment the memory of languege models with long-term memory, and enhancing of responses and recall accuracy. Certain directories for this service are made available to the host machine for the purposes of data persistence."
      - "local.service.source.url=https://github.com/neo4j/neo4j"
      - "portainer.agent.stack=true"  
    <<: *common_neo4j
    env_file:
      - $PRODUCTION_NEO4J_ENVIRONMENT_FILE
    ports:
      - "7474:7474"
      - "7687:7687"
    healthcheck:
      test: ["CMD", "wget", "--no-verbose", "--tries=1", "--spider", "http://production_neo4j:7474/browser/"]
      interval: 30s
      timeout: 10s
      retries: 5
      start_period: 40s  
    logging:
      <<: *default-logging
      options:
        tag: "production-database/{{.Name}}"  
    volumes:
      - host_production_neo4j_data_volume:/data
      - host_production_neo4j_logs_volume:/logs
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
    container_name: development_phpfpm_apache  
    labels:
      - "local.service.name=Development - Web Server: PHP-fpm Apache2"
      - "local.service.description=Development web server. Certain directories for this service are made available to the host machine for the purposes of data persistence."      
      - "local.service.source.url=https://github.com/shinsenter/php"
      - "portainer.agent.stack=true"  
    <<: *common_phpfpm_apache
    env_file:
      - $DEVELOPMENT_PHPFPM_APACHE_ENVIRONMENT_FILE
    ports:
      - "8081:80"
      - "8444:443"
      - "8444:443/udp"
    healthcheck:
      test: ["CMD", "curl", "-f", "http://development_phpfpm_apache:80/"]
      interval: 30s
      timeout: 10s
      retries: 3
      start_period: 40s
    logging:
      <<: *default-logging
      options:
        tag: "development-webserver-phpfpm-apache/{{.Name}}"    
    volumes:
      - host_development_phpfpm_apache_data_apache_volume:/var/www/html
      - host_development_phpfpm_apache_config_php_volume:/usr/local/etc/php
      - host_development_phpfpm_apache_config_apache_volume:/usr/local/apache2/conf      
    networks:
      - core_monitoring_network
      - development_app_network

  # Development MariaDB
  # Accessible at: http://localhost:3307
  # Healthcheck status: working
  development_mariadb:
    container_name: development_mariadb    
    labels:
      - "local.service.name=Development - DB Server: MariaDB"
      - "local.service.description=Development MariaDB database server. Certain directories for this service are made available to the host machine for the purposes of data persistence."
      - "local.service.source.url=https://github.com/MariaDB/server"
      - "portainer.agent.stack=true"  
    <<: *common_mariadb
    env_file:
      - $DEVELOPMENT_MARIADB_ENVIRONMENT_FILE
    ports:
      - "3307:3306"
    healthcheck:
      test: ["CMD", "mysqladmin", "ping", "-h", "development_mariadb"]
      interval: 30s
      timeout: 10s
      retries: 3
      start_period: 40s
    logging:
      <<: *default-logging
      options:
        tag: "development-database-mariadb/{{.Name}}"
    volumes:
      - host_development_mariadb_data_mysql_volume:/var/lib/mysql
    networks:
      - core_monitoring_network
      - development_app_network
      - development_db_network

  # Development Neo4j
  # Accessible at: http://localhost:7475
  # Healthcheck status: working
  development_neo4j:
    container_name: development_neo4j    
    labels:
      - "local.service.name=Development - DB Server: Neo4j"
      - "local.service.description=Development Neo4j database server for knowledge graphs. The purpose of this service is to provide augment the memory of languege models with long-term memory, and enhancing of responses and recall accuracy. Certain directories for this service are made available to the host machine for the purposes of data persistence."
      - "local.service.source.url=https://github.com/neo4j/neo4j"
      - "portainer.agent.stack=true"  
    <<: *common_neo4j
    env_file:
      - $DEVELOPMENT_NEO4J_ENVIRONMENT_FILE
    ports:
      - "7475:7474"
      - "7688:7687"
    healthcheck:
      test: ["CMD", "wget", "--no-verbose", "--tries=1", "--spider", "http://development_neo4j:7474/browser/"]
      interval: 30s
      timeout: 10s
      retries: 5
      start_period: 40s  
    logging:
      <<: *default-logging
      options:
        tag: "development-database/{{.Name}}"
    volumes:
      - host_development_neo4j_data_volume:/data
      - host_development_neo4j_logs_volume:/logs
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
create_project_structure

# Get current user's UID and GID
CURRENT_UID=$(id -u)
CURRENT_GID=$(id -g)

# Fix permissions for docker volumes
fix_permissions() {
  local path="$1"
  
  echo "Fixing permissions for $path..."
  if [ -d "$path" ]; then
    chown -R $CURRENT_UID:$CURRENT_GID "$path"
    #chmod -R u=rwX,g=rX,o= "$path"
    echo "Set ownership to $CURRENT_UID:$CURRENT_GID for $path"
  else
    echo "Warning: Directory $path does not exist"
  fi
}

# Fix permissions for all data directories
echo "Fixing permissions for data directories..."
for dir in $HOME/.docker/*/data/*; do
  if [ -d "$dir" ]; then
    fix_permissions "$dir"
  fi
done

generate_secrets
create_docker_configs

log "Project setup complete!"
log "To start the project, run: docker-compose up -d --build"
