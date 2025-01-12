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

# Define core service data path, environment file variables, and ports
CORE_PORTAINER_DATA_PATH="$CORE_DATA_PATH/portainer"
CORE_PORTAINER_ENVIRONMENT_FILE="$CORE_SECRETS_PATH/.portainer.env"
CORE_PORTAINER_HOST_HTTP_PORT=9000
CORE_PORTAINER_CONTAINER_HTTP_PORT=9000

CORE_SEARXNG_DATA_PATH="$CORE_DATA_PATH/searxng"
CORE_SEARXNG_ENVIRONMENT_FILE="$CORE_SECRETS_PATH/.searxng.env"
CORE_SEARXNG_HOST_HTTP_PORT=8084
CORE_SEARXNG_CONTAINER_HTTP_PORT=8080

CORE_PGADMIN_DATA_PATH="$CORE_DATA_PATH/pgadmin"
CORE_PGADMIN_ENVIRONMENT_FILE="$CORE_SECRETS_PATH/.pgadmin.env"
CORE_PGADMIN_HOST_HTTP_PORT=8082
CORE_PGADMIN_CONTAINER_HTTP_PORT=80

CORE_PHPMYADMIN_DATA_PATH="$CORE_DATA_PATH/phpmyadmin"
CORE_PHPMYADMIN_ENVIRONMENT_FILE="$CORE_SECRETS_PATH/.phpmyadmin.env"
CORE_PHPMYADMIN_HOST_HTTP_PORT=8083
CORE_PHPMYADMIN_CONTAINER_HTTP_PORT=80

CORE_OLLAMA_DATA_PATH="$CORE_DATA_PATH/ollama"
CORE_OLLAMA_ENVIRONMENT_FILE="$CORE_SECRETS_PATH/.ollama.env"
CORE_OLLAMA_HOST_HTTP_PORT=11434
CORE_OLLAMA_CONTAINER_HTTP_PORT=11434

CORE_OPENWEBUI_DATA_PATH="$CORE_DATA_PATH/openwebui"
CORE_OPENWEBUI_ENVIRONMENT_FILE="$CORE_SECRETS_PATH/.openwebui.env"
CORE_OPENWEBUI_HOST_HTTP_PORT=11435
CORE_OPENWEBUI_CONTAINER_HTTP_PORT=8080

CORE_KOKORO_TTS_DATA_PATH="$CORE_DATA_PATH/kokoro_tts"
CORE_KOKORO_TTS_ENVIRONMENT_FILE="$CORE_SECRETS_PATH/.kokoro_tts.env"
CORE_KOKORO_TTS_HOST_HTTP_PORT=8085
CORE_KOKORO_TTS_CONTAINER_HTTP_PORT=8880

CORE_KOKORO_WEBUI_DATA_PATH="$CORE_DATA_PATH/kokoro_webui"
CORE_KOKORO_WEBUI_ENVIRONMENT_FILE="$CORE_SECRETS_PATH/.kokoro_webui.env"
CORE_KOKORO_WEBUI_HOST_HTTP_PORT=7860
CORE_KOKORO_WEBUI_CONTAINER_HTTP_PORT=7860

# Define production service data path and environment file variables
PRODUCTION_PHPFPM_APACHE_DATA_PATH="$PRODUCTION_DATA_PATH/phpfpm_apache"
PRODUCTION_PHPFPM_APACHE_ENVIRONMENT_FILE="$PRODUCTION_SECRETS_PATH/.phpfpm_apache.env" 
PRODUCTION_PHPFPM_APACHE_HOST_HTTP_PORT=8080
PRODUCTION_PHPFPM_APACHE_CONTAINER_HTTP_PORT=80
PRODUCTION_PHPFPM_APACHE_HOST_HTTPS_PORT=8443
PRODUCTION_PHPFPM_APACHE_CONTAINER_HTTPS_PORT=443

PRODUCTION_POSTGRES_DATA_PATH="$PRODUCTION_DATA_PATH/postgres"
PRODUCTION_POSTGRES_ENVIRONMENT_FILE="$PRODUCTION_SECRETS_PATH/.postgres.env"
PRODUCTION_POSTGRES_HOST_TCP_PORT=5432
PRODUCTION_POSTGRES_CONTAINER_TCP_PORT=5432

PRODUCTION_MARIADB_DATA_PATH="$PRODUCTION_DATA_PATH/mariadb"
PRODUCTION_MARIADB_ENVIRONMENT_FILE="$PRODUCTION_SECRETS_PATH/.mariadb.env"
PRODUCTION_MARIADB_HOST_TCP_PORT=3306
PRODUCTION_MARIADB_CONTAINER_TCP_PORT=3306

PRODUCTION_NEO4J_DATA_PATH="$PRODUCTION_DATA_PATH/neo4j"
PRODUCTION_NEO4J_ENVIRONMENT_FILE="$PRODUCTION_SECRETS_PATH/.neo4j.env"
PRODUCTION_NEO4J_HOST_HTTP_PORT=7474
PRODUCTION_NEO4J_CONTAINER_HTTP_PORT=7474
PRODUCTION_NEO4J_HOST_BOLT_PORT=7687
PRODUCTION_NEO4J_CONTAINER_BOLT_PORT=7687

# Define development service data path and environment file variables
DEVELOPMENT_PHPFPM_APACHE_DATA_PATH="$DEVELOPMENT_DATA_PATH/phpfpm_apache"
DEVELOPMENT_PHPFPM_APACHE_ENVIRONMENT_FILE="$DEVELOPMENT_SECRETS_PATH/.phpfpm_apache.env"
DEVELOPMENT_PHPFPM_APACHE_HOST_HTTP_PORT=8081
DEVELOPMENT_PHPFPM_APACHE_CONTAINER_HTTP_PORT=80
DEVELOPMENT_PHPFPM_APACHE_HOST_HTTPS_PORT=8444
DEVELOPMENT_PHPFPM_APACHE_CONTAINER_HTTPS_PORT=443

DEVELOPMENT_POSTGRES_DATA_PATH="$DEVELOPMENT_DATA_PATH/postgres"
DEVELOPMENT_POSTGRES_ENVIRONMENT_FILE="$DEVELOPMENT_SECRETS_PATH/.postgres.env"
DEVELOPMENT_POSTGRES_HOST_TCP_PORT=5433
DEVELOPMENT_POSTGRES_CONTAINER_TCP_PORT=5432

DEVELOPMENT_MARIADB_DATA_PATH="$DEVELOPMENT_DATA_PATH/mariadb"
DEVELOPMENT_MARIADB_ENVIRONMENT_FILE="$DEVELOPMENT_SECRETS_PATH/.mariadb.env"
DEVELOPMENT_MARIADB_HOST_TCP_PORT=3307
DEVELOPMENT_MARIADB_CONTAINER_TCP_PORT=3306

DEVELOPMENT_NEO4J_DATA_PATH="$DEVELOPMENT_DATA_PATH/neo4j"
DEVELOPMENT_NEO4J_ENVIRONMENT_FILE="$DEVELOPMENT_SECRETS_PATH/.neo4j.env"
DEVELOPMENT_NEO4J_HOST_HTTP_PORT=7475
DEVELOPMENT_NEO4J_CONTAINER_HTTP_PORT=7474
DEVELOPMENT_NEO4J_HOST_BOLT_PORT=7688
DEVELOPMENT_NEO4J_CONTAINER_BOLT_PORT=7687

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
  sudo -u $USER mkdir -p $CORE_DATA_PATH/{portainer,searxng,pgadmin,phpmyadmin,ollama,openwebui,kokoro_tts,kokoro_webui} || error "Failed to create core service directories."
  sudo -u $USER mkdir -p $CORE_PGADMIN_DATA_PATH/storage_pgadmin || error "Failed to create core PGAdmin directories."
  sudo -u $USER mkdir -p $CORE_KOKORO_TTS_DATA_PATH/{data_src,data_models} || error "Failed to create core Kokoro TTS directories."

  # Create production service directories
  sudo -u $USER mkdir -p $PRODUCTION_DATA_PATH/{phpfpm_apache,postgres,mariadb,neo4j} || error "Failed to create production service directories."
  sudo -u $USER mkdir -p $PRODUCTION_PHPFPM_APACHE_DATA_PATH/{config_php,config_apache,data_apache} || error "Failed to create production PHP-fpm Apache directories."
  sudo -u $USER mkdir -p $PRODUCTION_POSTGRES_DATA_PATH/data_postgresql || error "Failed to create production Postgres directories."
  sudo -u $USER mkdir -p $PRODUCTION_MARIADB_DATA_PATH/data_mysql || error "Failed to create production MariaDB directories."
  sudo -u $USER mkdir -p $PRODUCTION_NEO4J_DATA_PATH/{data,logs} || error "Failed to create production Neo4j directories."
  # Create development service directories
  sudo -u $USER mkdir -p $DEVELOPMENT_DATA_PATH/{phpfpm_apache,postgres,mariadb,neo4j} || error "Failed to create development service directories."
  sudo -u $USER mkdir -p $DEVELOPMENT_PHPFPM_APACHE_DATA_PATH/{config_php,config_apache,data_apache} || error "Failed to create development PHP-fpm Apache directories."
  sudo -u $USER mkdir -p $DEVELOPMENT_POSTGRES_DATA_PATH/data_postgresql || error "Failed to create development Postgres directories."
  sudo -u $USER mkdir -p $DEVELOPMENT_MARIADB_DATA_PATH/data_mysql || error "Failed to create development MariaDB directories."
  sudo -u $USER mkdir -p $DEVELOPMENT_NEO4J_DATA_PATH/{data,logs} || error "Failed to create development Neo4j directories."
  # Set permissions
  sudo -u $USER chmod -R 755 $BASE_PATH || error "Failed to set permissions for $BASE_PATH."

  log "Project directory structure created successfully."  
}

# Function to generate a random string
generate_random_string() {
  #openssl rand -base64 32 | tr -d '/+=' | cut -c1-32
  cat /dev/urandom | tr -dc 'a-zA-Z0-9!@#%^&*()_+{}[]|:;<>?,.~`' | head -c 32
}

# Generate secure passwords
generate_secrets() {
  log "Generating secure secrets..."
  
  # Core secrets
  if [ ! -f "$CORE_PORTAINER_ENVIRONMENT_FILE" ]; then
    sudo -u $USER touch $CORE_PORTAINER_ENVIRONMENT_FILE || error "Failed to create core .portainer.env."
    echo "PORTAINER_ADMIN_PASSWORD=$(generate_random_string)" > $CORE_PORTAINER_ENVIRONMENT_FILE || error "Failed to write PORTAINER_ADMIN_PASSWORD to core .portainer.env."
  fi

  if [ ! -f "$CORE_SEARXNG_ENVIRONMENT_FILE" ]; then
    sudo -u $USER touch $CORE_SEARXNG_ENVIRONMENT_FILE || error "Failed to create core .searxng.env."
    echo "SEARXNG_BASE_URL=http://localhost:8084" > $CORE_SEARXNG_ENVIRONMENT_FILE || error "Failed to write BASE_URL to core .searxng.env."
    echo "INSTANCE_NAME=JTTW SearxNG" >> $CORE_SEARXNG_ENVIRONMENT_FILE || error "Failed to write INSTANCE_NAME to core .searxng.env."
    echo "UWSGI_WORKERS=4" >> $CORE_SEARXNG_ENVIRONMENT_FILE || error "Failed to write UWSGI_WORKERS to core .searxng.env."
    echo "UWSGI_THREADS=4" >> $CORE_SEARXNG_ENVIRONMENT_FILE || error "Failed to write UWSGI_THREADS to core .searxng.env."
    echo "SEARXNG_SEARCH_FORMATS=html,json" >> $CORE_SEARXNG_ENVIRONMENT_FILE || error "Failed to write SEARXNG_SETTINGS_SEARCH__FORMATS to core .searxng.env."
    echo "SEARXNG_SEARCH_DEFAULT_FORMAT=html" >> $CORE_SEARXNG_ENVIRONMENT_FILE || error "Failed to write SEARXNG_SETTINGS_SEARCH__DEFAULT_FORMAT to core .searxng.env."
  fi

  if [ ! -f "$CORE_PGADMIN_ENVIRONMENT_FILE" ]; then
    sudo -u $USER touch $CORE_PGADMIN_ENVIRONMENT_FILE || error "Failed to create core .pgadmin.env."
    echo "PGADMIN_DEFAULT_EMAIL=pgadmin@jttw-ai-docker-stack.com" > $CORE_PGADMIN_ENVIRONMENT_FILE || error "Failed to write PGADMIN_DEFAULT_EMAIL to core .pgadmin.env."
    echo "PGADMIN_DEFAULT_PASSWORD=$(generate_random_string)" >> $CORE_PGADMIN_ENVIRONMENT_FILE || error "Failed to write PGADMIN_DEFAULT_PASSWORD to core .pgadmin.env."
    echo "MASTER_PASSWORD_REQUIRED=False" >> $CORE_PGADMIN_ENVIRONMENT_FILE || error "Failed to write MASTER_PASSWORD_REQUIRED to core .pgadmin.env."
  fi

  if [ ! -f "$CORE_PHPMYADMIN_ENVIRONMENT_FILE" ]; then    
    sudo -u $USER touch $CORE_PHPMYADMIN_ENVIRONMENT_FILE || error "Failed to create core .phpmyadmin.env."
    echo "PMA_HOSTS=production_mariadb,development_mariadb" > $CORE_PHPMYADMIN_ENVIRONMENT_FILE || error "Failed to write PMA_HOSTS to core .phpmyadmin.env."
    echo "PMA_PORTS=$PRODUCTION_MARIADB_CONTAINER_TCP_PORT,$DEVELOPMENT_MARIADB_CONTAINER_TCP_PORT" >> $CORE_PHPMYADMIN_ENVIRONMENT_FILE || error "Failed to write PMA_PORTS to core .phpmyadmin.env."    
    # May need to add these in the future if I revisit deeper automated phpmyadmin configuration
    # echo "PMA_PMADB=development_mariadb" >> $CORE_PHPMYADMIN_ENVIRONMENT_FILE || error "Failed to write PMA_PMADB to core .phpmyadmin.env."
    # echo "PMA_CONTROLUSER=pma" >> $CORE_PHPMYADMIN_ENVIRONMENT_FILE || error "Failed to write PMA_CONTROLUSER to core .phpmyadmin.env."
    # echo "PMA_CONTROLPASS=$(generate_random_string)" >> $CORE_PHPMYADMIN_ENVIRONMENT_FILE || error "Failed to write PMA_CONTROLPASS to core .phpmyadmin.env."
  fi

  if [ ! -f "$CORE_OLLAMA_ENVIRONMENT_FILE" ]; then
    sudo -u $USER touch $CORE_OLLAMA_ENVIRONMENT_FILE || error "Failed to create core .ollama.env."
    echo "OLLAMA_FLASH_ATTENTION=1" > $CORE_OLLAMA_ENVIRONMENT_FILE || error "Failed to write OLLAMA_FLASH_ATTENTION to core .ollama.env."
    echo "OLLAMA_API_BASE_URL=http://127.0.0.1:$CORE_OLLAMA_CONTAINER_HTTP_PORT" >> $CORE_OLLAMA_ENVIRONMENT_FILE || error "Failed to write OLLAMA_BASE_URL to core .ollama.env."
    echo "OLLAMA_HOST=0.0.0.0" >> $CORE_OLLAMA_ENVIRONMENT_FILE || error "Failed to write OLLAMA_HOST to core .ollama.env."
  fi

  if [ ! -f "$CORE_OPENWEBUI_ENVIRONMENT_FILE" ]; then
    sudo -u $USER touch $CORE_OPENWEBUI_ENVIRONMENT_FILE || error "Failed to create core .openwebui.env."
    echo "WEBUI_SECRET_KEY=$(generate_random_string)" > $CORE_OPENWEBUI_ENVIRONMENT_FILE || error "Failed to write WEBUI_SECRET_KEY to core .openwebui.env."    
    echo "OLLAMA_BASE_URLS=http://core_ollama:$CORE_OLLAMA_CONTAINER_HTTP_PORT" >> $CORE_OPENWEBUI_ENVIRONMENT_FILE || error "Failed to write OLLAMA_BASE_URLS to core .openwebui.env."
    echo "RAG_EMBEDDING_ENGINE=ollama" >> $CORE_OPENWEBUI_ENVIRONMENT_FILE || error "Failed to write RAG_EMBEDDING_ENGINE to core .openwebui.env."
    echo "RAG_OLLAMA_BASE_URL=http://core_ollama:$CORE_OLLAMA_CONTAINER_HTTP_PORT" >> $CORE_OPENWEBUI_ENVIRONMENT_FILE || error "Failed to write RAG_OPENAI_API_BASE_URL to core .openwebui.env."
    echo "RAG_EMBEDDING_MODEL=mxbai-embed-large" >> $CORE_OPENWEBUI_ENVIRONMENT_FILE || error "Failed to write RAG_EMBEDDING_MODEL to core .openwebui.env."
    echo "ENABLE_RAG_WEB_SEARCH=True" >> $CORE_OPENWEBUI_ENVIRONMENT_FILE || error "Failed to write ENABLE_RAG_WEB_SEARCH to core .openwebui.env."
    echo "ENABLE_SEARCH_QUERY=True" >> $CORE_OPENWEBUI_ENVIRONMENT_FILE || error "Failed to write ENABLE_SEARCH_QUERY to core .openwebui.env."
    echo "RAG_WEB_SEARCH_ENGINE=searxng" >> $CORE_OPENWEBUI_ENVIRONMENT_FILE || error "Failed to write RAG_WEB_SEARCH_ENGINE to core .openwebui.env."
    echo "SEARXNG_QUERY_URL=http://core_searxng:8080/search?q=<query>&format=json" >> $CORE_OPENWEBUI_ENVIRONMENT_FILE || error "Failed to write SEARXNG_QUERY_URL to core .openwebui.env."
    echo "RAG_WEB_SEARCH_RESULT_COUNT=5" >> $CORE_OPENWEBUI_ENVIRONMENT_FILE || error "Failed to write RAG_WEB_SEARCH_RESULT_COUNT to core .openwebui.env."
    echo "RAG_WEB_SEARCH_CONCURRENT_REQUESTS=10" >> $CORE_OPENWEBUI_ENVIRONMENT_FILE || error "Failed to write RAG_WEB_SEARCH_CONCURRENT_REQUESTS to core .openwebui.env."
  fi

  if [ ! -f "$CORE_KOKORO_TTS_ENVIRONMENT_FILE" ]; then
    sudo -u $USER touch $CORE_KOKORO_TTS_ENVIRONMENT_FILE || error "Failed to create core .kokoro_tts.env."
    echo "PYTHONUNBUFFERED=1" > $CORE_KOKORO_TTS_ENVIRONMENT_FILE || error "Failed to write PYTHONUNBUFFERED to core .kokoro_tts.env."
    echo "PYTHONPATH=/app:/app/Kokoro-82M" >> $CORE_KOKORO_TTS_ENVIRONMENT_FILE || error "Failed to write PYTHONPATH to core .kokoro_tts.env."
    echo "PATH=/home/appuser/.local/bin:\$PATH" >> $CORE_KOKORO_TTS_ENVIRONMENT_FILE || error "Failed to write PATH to core .kokoro_tts.env."
  fi

  if [ ! -f "$CORE_KOKORO_WEBUI_ENVIRONMENT_FILE" ]; then
    sudo -u $USER touch $CORE_KOKORO_WEBUI_ENVIRONMENT_FILE || error "Failed to create core .kokoro_webui.env."
  fi

  # Production secrets
  if [ ! -f "$PRODUCTION_POSTGRES_ENVIRONMENT_FILE" ]; then
    sudo -u $USER touch $PRODUCTION_POSTGRES_ENVIRONMENT_FILE || error "Failed to create production .postgres.env."
    echo "POSTGRES_USER=production_user" > $PRODUCTION_POSTGRES_ENVIRONMENT_FILE || error "Failed to write POSTGRES_USER to production .postgres.env."
    echo "POSTGRES_PASSWORD=$(generate_random_string)" >> $PRODUCTION_POSTGRES_ENVIRONMENT_FILE || error "Failed to write POSTGRES_PASSWORD to production .postgres.env."
    echo "POSTGRES_DB=production" >> $PRODUCTION_POSTGRES_ENVIRONMENT_FILE || error "Failed to write POSTGRES_DB to production .postgres.env."
  fi

  if [ ! -f "$PRODUCTION_MARIADB_ENVIRONMENT_FILE" ]; then
    sudo -u $USER touch $PRODUCTION_MARIADB_ENVIRONMENT_FILE || error "Failed to create production .mariadb.env."
    echo "MARIADB_ROOT_PASSWORD=$(generate_random_string)" > $PRODUCTION_MARIADB_ENVIRONMENT_FILE || error "Failed to write MARIADB_ROOT_PASSWORD to production .mariadb.env."
    echo "MARIADB_DATABASE=production" >> $PRODUCTION_MARIADB_ENVIRONMENT_FILE || error "Failed to write MARIADB_DATABASE to production .mariadb.env."
    echo "MARIADB_USER=production_user" >> $PRODUCTION_MARIADB_ENVIRONMENT_FILE || error "Failed to write MARIADB_USER to production .mariadb.env."
    echo "MARIADB_PASSWORD=$(generate_random_string)" >> $PRODUCTION_MARIADB_ENVIRONMENT_FILE || error "Failed to write MARIADB_PASSWORD to production .mariadb.env."
  fi

  if [ ! -f "$PRODUCTION_NEO4J_ENVIRONMENT_FILE" ]; then
    sudo -u $USER touch $PRODUCTION_NEO4J_ENVIRONMENT_FILE || error "Failed to create production .neo4j.env."
    echo "NEO4J_AUTH=neo4j/$(generate_random_string)" > $PRODUCTION_NEO4J_ENVIRONMENT_FILE || error "Failed to write NEO4J_AUTH to production .neo4j.env."    
  fi

  if [ ! -f "$PRODUCTION_PHPFPM_APACHE_ENVIRONMENT_FILE" ]; then
    sudo -u $USER touch $PRODUCTION_PHPFPM_APACHE_ENVIRONMENT_FILE || error "Failed to create production .phpfpm_apache.env."
    echo "PHP_FPM_PASSWORD=$(generate_random_string)" > $PRODUCTION_PHPFPM_APACHE_ENVIRONMENT_FILE || error "Failed to write PHP_FPM_PASSWORD to production .phpfpm_apache.env."
    echo "APACHE2_PASSWORD=$(generate_random_string)" >> $PRODUCTION_PHPFPM_APACHE_ENVIRONMENT_FILE || error "Failed to write APACHE2_PASSWORD to production .phpfpm_apache.env." 
    
  fi

  # Development secrets
  if [ ! -f "$DEVELOPMENT_POSTGRES_ENVIRONMENT_FILE" ]; then
    sudo -u $USER touch $DEVELOPMENT_POSTGRES_ENVIRONMENT_FILE || error "Failed to create development .postgres.env."
    echo "POSTGRES_USER=development_user" > $DEVELOPMENT_POSTGRES_ENVIRONMENT_FILE || error "Failed to write POSTGRES_USER to development .postgres.env."
    echo "POSTGRES_PASSWORD=$(generate_random_string)" >> $DEVELOPMENT_POSTGRES_ENVIRONMENT_FILE || error "Failed to write POSTGRES_PASSWORD to development .postgres.env."
    echo "POSTGRES_DB=development" >> $DEVELOPMENT_POSTGRES_ENVIRONMENT_FILE || error "Failed to write POSTGRES_DB to development .postgres.env."
  fi

  if [ ! -f "$DEVELOPMENT_MARIADB_ENVIRONMENT_FILE" ]; then
    sudo -u $USER touch $DEVELOPMENT_MARIADB_ENVIRONMENT_FILE || error "Failed to create development .mariadb.env."
    echo "MARIADB_ROOT_PASSWORD=$(generate_random_string)" > $DEVELOPMENT_MARIADB_ENVIRONMENT_FILE || error "Failed to write MARIADB_ROOT_PASSWORD to development .mariadb.env."
    echo "MARIADB_DATABASE=development" >> $DEVELOPMENT_MARIADB_ENVIRONMENT_FILE || error "Failed to write MARIADB_DATABASE to development .mariadb.env."
    echo "MARIADB_USER=development_user" >> $DEVELOPMENT_MARIADB_ENVIRONMENT_FILE || error "Failed to write MARIADB_USER to development .mariadb.env."
    echo "MARIADB_PASSWORD=$(generate_random_string)" >> $DEVELOPMENT_MARIADB_ENVIRONMENT_FILE || error "Failed to write MARIADB_PASSWORD to development .mariadb.env."
  fi

  if [ ! -f "$DEVELOPMENT_NEO4J_ENVIRONMENT_FILE" ]; then
    sudo -u $USER touch $DEVELOPMENT_NEO4J_ENVIRONMENT_FILE || error "Failed to create development.neo4j.env."
    echo "NEO4J_AUTH=neo4j/$(generate_random_string)" > $DEVELOPMENT_NEO4J_ENVIRONMENT_FILE || error "Failed to write NEO4J_AUTH to development .neo4j.env."
  fi

  if [ ! -f "$DEVELOPMENT_PHPFPM_APACHE_ENVIRONMENT_FILE" ]; then
    sudo -u $USER touch $DEVELOPMENT_PHPFPM_APACHE_ENVIRONMENT_FILE || error "Failed to create development .phpfpm_apache.env."
    echo "PHP_FPM_PASSWORD=$(generate_random_string)" > $DEVELOPMENT_PHPFPM_APACHE_ENVIRONMENT_FILE || error "Failed to write PHP_FPM_PASSWORD to development .phpfpm_apache.env."
    echo "APACHE2_PASSWORD=$(generate_random_string)" >> $DEVELOPMENT_PHPFPM_APACHE_ENVIRONMENT_FILE || error "Failed to write APACHE2_PASSWORD to development .phpfpm_apache.env."
      
  fi

  # Set specific permissions for secrets directories
  sudo -u $USER chmod -R 700 $BASE_PATH/*/secrets/ || error "Failed to set permissions for secrets directories."

  log "Secrets generated and stored successfully"
}

# Create Docker configuration files
create_docker_configs() {
  log "Creating Docker configuration files..."

  cat > docker-compose.yml << EOF
# To stop the containers, run: sudo -S docker compose down --remove-orphans
# To remove the containers, run: sudo -S docker compose down --remove-orphans && sudo -S docker system prune -af
# To list the containers, run: sudo -S docker ps -a && echo '=== Images ===' && echo darkness | sudo -S docker images && echo '=== Networks ===' && echo darkness | sudo -S docker network ls
# To remove all persisted volume data, run: sudo rm -rf $BASE_PATH
# To rebuild the project, run: cd $HOME/Documents/projects/jttw-ai-docker-stack && bash setup.sh
# To start the project, run: cd $HOME/Documents/projects/jttw-ai-docker-stack && sudo -S docker compose up -d
# Example to get a docker containers logs: docker logs production_mariadb
# Example to execute a command in a container: docker exec core_ollama ollama list

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
  host_core_searxng_storage_volume:
    driver: local
    driver_opts:
      type: none
      device: $CORE_SEARXNG_DATA_PATH/
      o: bind
  host_core_pgadmin_storage_volume:
    driver: local
    driver_opts:
      type: none
      device: $CORE_PGADMIN_DATA_PATH/storage_pgadmin/
      o: bind            
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
  host_core_kokoro_tts_data_src_volume:
    driver: local
    driver_opts:
      type: none
      device: $CORE_KOKORO_TTS_DATA_PATH/data_src/
      o: bind    
  host_core_kokoro_tts_data_models_volume:
    driver: local
    driver_opts:
      type: none
      device: $CORE_KOKORO_TTS_DATA_PATH/data_models/
      o: bind 
  host_core_kokoro_webui_storage_volume:
    driver: local
    driver_opts:
      type: none
      device: $CORE_KOKORO_WEBUI_DATA_PATH/
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
  host_production_postgres_data_postgresql_volume:
    driver: local
    driver_opts:
      type: none
      device: $PRODUCTION_POSTGRES_DATA_PATH/data_postgresql/
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
  host_development_postgres_data_postgresql_volume:
    driver: local
    driver_opts:
      type: none
      device: $DEVELOPMENT_POSTGRES_DATA_PATH/data_postgresql/
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

# Logging configuration

x-logging: &default-logging
  driver: "json-file"
  options:
    max-size: "1m"
    max-file: "1"
    tag: "{{.Name}}/{{.ID}}"  

# Common services configuration

x-common_phpfpm_apache: &common_phpfpm_apache
  image: shinsenter/phpfpm-apache:php8
  restart: unless-stopped 
  deploy:
    resources:
      limits:
        cpus: '0.50'
        memory: 512M

x-common_postgres: &common_postgres
  image: postgres:12.22
  restart: unless-stopped
  deploy:
    resources:
      limits:
        cpus: '1.0'
        memory: 1G
  healthcheck:
    test: ["CMD-SHELL", "pg_isready"]
    interval: 30s
    timeout: 10s
    retries: 3
    start_period: 40s    

x-common_mariadb: &common_mariadb        
  image: mariadb:10.6
  restart: unless-stopped
  deploy:
    resources:
      limits:
        cpus: '1.0'
        memory: 1G

x-common_neo4j: &common_neo4j
  # image: neo4j:5.7.0-community
  image: neo4j:5.26.0-community
  restart: unless-stopped
  depends_on:
    core_ollama:
      condition: service_healthy    
  deploy:
    resources:
      limits:
        cpus: '1.0'
        memory: 2G

# Special configurations

configs:               
  preferences.json:
    content: |
      {
        "preferences": {
          "misc:themes:theme": "dark",
          "browser:display:show_system_objects": true,
          "browser:display:confirm_on_refresh_close": false,
          "browser:display:show_user_defined_templates": true
        }
      }
  servers.json:
    content: |
      {
        "Servers": {
          "1": {
            "Name": "Production PostgreSQL",
            "Group": "Servers",
            "Host": "production_postgres",
            "Port": $PRODUCTION_POSTGRES_CONTAINER_TCP_PORT,
            "MaintenanceDB": "postgres",
            "Username": "production_user",
            "SSLMode": "prefer"
          },
          "2": {
            "Name": "Development PostgreSQL",
            "Group": "Servers",
            "Host": "development_postgres",
            "Port": $DEVELOPMENT_POSTGRES_CONTAINER_TCP_PORT,
            "MaintenanceDB": "postgres",
            "Username": "development_user",
            "SSLMode": "prefer"
          }
        }
      }
      

services:
# Core Services

  # Core Portainer Service
  # Host Accessible at: http://localhost:$CORE_PORTAINER_HOST_HTTP_PORT
  # Docker Accessible at: http://localhost:$CORE_PORTAINER_CONTAINER_HTTP_PORT
  # Healthcheck status: Not sure how to healthcheck Portainer because it lacks bash and shell. http://core_portainer:$CORE_PORTAINER_HOST_HTTP_PORT/api/system/status would be the best
  
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
      - "$CORE_PORTAINER_HOST_HTTP_PORT:$CORE_PORTAINER_CONTAINER_HTTP_PORT"
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


  # Core SearxNG Service
  ## Host Accessible at: http://localhost:$CORE_SEARXNG_HOST_HTTP_PORT
  # Docker Accessible at: http://localhost:$CORE_SEARXNG_CONTAINER_HTTP_PORT
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
      - "$CORE_SEARXNG_HOST_HTTP_PORT:$CORE_SEARXNG_CONTAINER_HTTP_PORT" 
    healthcheck:
      test: ["CMD", "wget", "--no-verbose", "--tries=1", "--spider", "http://core_searxng:$CORE_SEARXNG_CONTAINER_HTTP_PORT/"]
      interval: 30s
      timeout: 10s
      retries: 5
      start_period: 40s
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
      - production_app_network
      - development_app_network  


  # Core PGAdmin Service
  # Host Accessible at: http://localhost:$CORE_PGADMIN_HOST_HTTP_PORT
  # Docker Accessible at: http://localhost:$CORE_PGADMIN_CONTAINER_HTTP_PORT
  # Healthcheck status: working

  core_pgadmin:
    container_name: core_pgadmin
    image: dpage/pgadmin4:8.14.0
    restart: unless-stopped
    labels:
      - "local.service.name=CORE - DB Web UI: PGAdmin"
      - "local.service.description=Core PGAdmin database web ui for Postgres. Certain directories for this service are made available to the host machine for the purposes of data persistence."
      - "local.service.source.url=https://github.com/pgadmin-org/pgadmin4"
      - "portainer.agent.stack=true"
    env_file:
      - $CORE_PGADMIN_ENVIRONMENT_FILE
    ports:
      - "$CORE_PGADMIN_HOST_HTTP_PORT:$CORE_PGADMIN_CONTAINER_HTTP_PORT"  
    healthcheck:
      test: ["CMD", "curl", "-f", "http://core_pgadmin:$CORE_PGADMIN_CONTAINER_HTTP_PORT/"]
      interval: 30s
      timeout: 10s
      retries: 3
      start_period: 40s
    depends_on:
      production_postgres:
        condition: service_healthy
      development_postgres:
        condition: service_healthy
    volumes:
      - host_core_pgadmin_storage_volume:/var/lib/pgadmin
    configs:
      - source: servers.json
        target: /pgadmin4/servers.json
      - source: preferences.json
        target: /pgadmin4/preferences.json        
    deploy:
      resources:
        limits:
          cpus: '0.50'
          memory: 512M
    logging:
      <<: *default-logging
      options:
        tag: "core-db-ui-pgadmin/{{.Name}}"        
    networks:
      - core_monitoring_network
      - production_db_network
      - development_db_network    


  # Core PhpMyAdmin Service
  # Host Accessible at: http://localhost:$CORE_PHPMYADMIN_HOST_HTTP_PORT
  # Docker Accessible at: http://localhost:$CORE_PHPMYADMIN_CONTAINER_HTTP_PORT
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
      - "$CORE_PHPMYADMIN_HOST_HTTP_PORT:$CORE_PHPMYADMIN_CONTAINER_HTTP_PORT"  
    healthcheck:
      test: ["CMD", "curl", "-f", "http://core_phpmyadmin:$CORE_PHPMYADMIN_CONTAINER_HTTP_PORT/"]
      interval: 30s
      timeout: 10s
      retries: 3
      start_period: 40s
    depends_on:
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
        tag: "core-db-ui-phpmyadmin/{{.Name}}"    
    volumes:
      - host_core_phpmyadmin_storage_volume:/etc/apache2/conf-enabled
      - host_core_phpmyadmin_storage_volume:/etc/httpd             
    networks:
      - core_monitoring_network
      - production_db_network
      - development_db_network


  # Core Ollama Service
  # Host Accessible at: http://localhost:$CORE_OLLAMA_HOST_HTTP_PORT
  # Docker Accessible at: http://localhost:$CORE_OLLAMA_CONTAINER_HTTP_PORT
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
      - "$CORE_OLLAMA_HOST_HTTP_PORT:$CORE_OLLAMA_CONTAINER_HTTP_PORT"      
    healthcheck:
      test: ["CMD-SHELL", "curl -f http://core_ollama:$CORE_OLLAMA_CONTAINER_HTTP_PORT/api/version || exit 1"]
      interval: 30s
      timeout: 10s
      retries: 3
      start_period: 40s      
    entrypoint: /bin/sh
    command: |
      -c '
      # Define all functions
      check_server() {
        curl -s http://core_ollama:$CORE_OLLAMA_CONTAINER_HTTP_PORT/api/version >/dev/null 2>&1
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

      echo "Downloading qwen2.5:7b..."
      if ! /bin/ollama pull qwen2.5:7b; then
        echo "Failed to download qwen2.5:7b"
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
    # runtime: nvidia
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
  # Host Accessible at: http://localhost:$CORE_OPENWEBUI_HOST_HTTP_PORT
  # Docker Accessible at: http://localhost:$CORE_OPENWEBUI_HOST_HTTP_PORT
  # Healthcheck status: working

  core_openwebui:
    container_name: core_openwebui
    image: ghcr.io/open-webui/open-webui:git-1dfb479
    labels:
      - "local.service.name=Core - LLM Web UI: OpenWebUI"
      - "local.service.description=Core OpenWebUI web ui for chatting with LLMs. This service must be able to communitcate with the Ollama inference server via port $CORE_OLLAMA_CONTAINER_HTTP_PORT. Certain directories for this service are made available to the host machine for the purposes of data persistence."
      - "local.service.source.url=https://github.com/open-webui/open-webui"
      - "portainer.agent.stack=true"
    restart: unless-stopped
    env_file:
      - $CORE_OPENWEBUI_ENVIRONMENT_FILE
    ports:
      - "$CORE_OPENWEBUI_HOST_HTTP_PORT:$CORE_OPENWEBUI_CONTAINER_HTTP_PORT"
    healthcheck:  
      test: ["CMD-SHELL", "curl -f http://core_openwebui:$CORE_OPENWEBUI_CONTAINER_HTTP_PORT/auth || exit 1"]
      interval: 30s
      timeout: 10s
      retries: 3
      start_period: 40s
    depends_on:
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

  # Core Kokoro TTS Service
  # Host Accessible at: http://localhost:$CORE_KOKORO_TTS_HOST_HTTP_PORT
  # Docker Accessible at: http://localhost:$CORE_KOKORO_TTS_HOST_HTTP_PORT
  # Healthcheck status: working

  core_kokoro_tts:
    container_name: core_kokoro_tts
    image: ghcr.io/remsky/kokoro-fastapi:latest
    labels:
      - "local.service.name=Core - LLM Web UI: Kokoro TTS"
      - "local.service.description=Core Kokoro TTS fast api for text-to-speech. Certain directories for this service are made available to the host machine for the purposes of data persistence."
      - "local.service.source.url=https://github.com/remsky/Kokoro-FastAPI"
      - "portainer.agent.stack=true"
    restart: unless-stopped
    env_file:
      - $CORE_KOKORO_TTS_ENVIRONMENT_FILE
    ports:
      - "$CORE_KOKORO_TTS_HOST_HTTP_PORT:$CORE_KOKORO_TTS_CONTAINER_HTTP_PORT"
    healthcheck:  
      test: ["CMD", "curl", "-f", "http://core_kokoro_tts:$CORE_KOKORO_TTS_CONTAINER_HTTP_PORT/v1/audio/voices"]
      interval: 30s
      timeout: 10s
      retries: 3
      start_period: 40s      
    entrypoint: /bin/sh
    command: |
      -c '
      cd /app
      
      echo "Installing dependencies..."
      apt-get update && apt-get install -y --no-install-recommends python3-pip python3-dev espeak-ng curl unzip git git-lfs libsndfile1
      apt-get clean
      rm -rf /var/lib/apt/lists/
      git lfs install
      
      echo "Creating appuser..."
      useradd -m -u 1000 appuser || true
      
      echo "Setting owner of app directory to appuser..."
      chown -R appuser:appuser /app
      
      echo "Checking and updating repositories..."  

      # Handle Kokoro-82M repository
      if [ -d "/app/Kokoro-82M" ]; then
        echo "Removing any existing index.lock file..."
        rm -f /app/Kokoro-82M/.git/index.lock      
        echo "Updating Kokoro-82M repository..."
        cd /app/Kokoro-82M
        if [ -d ".git" ]; then
          git config --global --add safe.directory /app/Kokoro-82M
          git fetch origin
          git reset --hard origin/main || true
        fi
      else
        echo "Removing any existing index.lock file..."
        rm -f /app/Kokoro-82M/.git/index.lock           
        echo "Cloning Kokoro-82M repository..."
        git clone https://huggingface.co/hexgrad/Kokoro-82M
      fi
      
      # Handle Kokoro-FastAPI repository
      if [ ! -d "/app/.github" ]; then
        echo "Downloading and extracting Kokoro-FastAPI..."
        cd /app
        curl -L https://github.com/remsky/Kokoro-FastAPI/archive/refs/heads/master.zip -o kokoro.zip && \
        unzip -o kokoro.zip && \
        cp -rf Kokoro-FastAPI-master/* . && \
        cp -rf Kokoro-FastAPI-master/.[!.]* . 2>/dev/null || true && \
        rm -rf Kokoro-FastAPI-master kokoro.zip
      fi
      
      echo "Installing requirements..."
      cd /app
      su appuser -c "python3 -m pip install --upgrade pip"
      su appuser -c "pip3 cache purge"
      su appuser -c "pip3 install --no-cache-dir torch==2.5.1 --extra-index-url https://download.pytorch.org/whl/cu121"
      if [ -f "requirements.txt" ]; then
        su appuser -c "pip3 install --no-cache-dir -r requirements.txt"
      fi
      su appuser -c "pip3 install loguru pydantic_settings scipy soundfile munch transformers phonemizer"
      
      echo "Starting server..."
      cd /app
      su appuser -c "uvicorn api.src.main:app --host 0.0.0.0 --port 8880 --log-level debug"'   
    deploy:
      resources:
        reservations:
          devices:
            - driver: nvidia
              capabilities: [gpu]
        limits:
          cpus: '0.50'
          memory: 8192M
    logging:
      <<: *default-logging
      options:
        tag: "core-tts-server/{{.Name}}"  
    volumes:
      - host_core_kokoro_tts_data_src_volume:/app/api/src
      - host_core_kokoro_tts_data_models_volume:/app/Kokoro-82M        
    networks:
      - core_monitoring_network      
      - core_ai_network
      - production_app_network
      - development_app_network

# Production Services

  # Production PHP-fpm Apache2
  # Host Accessible at: http://localhost:$PRODUCTION_PHPFPM_APACHE_HOST_HTTP_PORT
  # Docker Accessible at: http://localhost:$PRODUCTION_PHPFPM_APACHE_CONTAINER_HTTP_PORT
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
      - "$PRODUCTION_PHPFPM_APACHE_HOST_HTTP_PORT:$PRODUCTION_PHPFPM_APACHE_CONTAINER_HTTP_PORT"
      - "$PRODUCTION_PHPFPM_APACHE_HOST_HTTPS_PORT:$PRODUCTION_PHPFPM_APACHE_CONTAINER_HTTPS_PORT"
      - "$PRODUCTION_PHPFPM_APACHE_HOST_HTTPS_PORT:$PRODUCTION_PHPFPM_APACHE_CONTAINER_HTTP_PORT/udp"
    healthcheck:
      test: ["CMD", "curl", "-f", "http://production_phpfpm_apache:$PRODUCTION_PHPFPM_APACHE_CONTAINER_HTTP_PORT/"]
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


  # Production Postgres
  # Host Accessible at: http://localhost:$PRODUCTION_POSTGRES_HOST_TCP_PORT
  # Docker Accessible at: http://localhost:$PRODUCTION_POSTGRES_CONTAINER_TCP_PORT
  # Healthcheck status: working

  production_postgres:
    container_name: production_postgres
    labels:
      - "local.service.name=Production - DB Server: Postgres"
      - "local.service.description=Production Postgres database server. Certain directories for this service are made available to the host machine for the purposes of data persistence."
      - "local.service.source.url=https://github.com/postgres/postgres"
      - "portainer.agent.stack=true"  
    <<: *common_postgres
    env_file:
      - $PRODUCTION_POSTGRES_ENVIRONMENT_FILE
    ports:
      - "$PRODUCTION_POSTGRES_HOST_TCP_PORT:$PRODUCTION_POSTGRES_CONTAINER_TCP_PORT"
    logging:
      <<: *default-logging
      options:
        tag: "production-database-postgres/{{.Name}}"
    volumes:
      - host_production_postgres_data_postgresql_volume:/var/lib/postgresql/data
    networks:
      - core_monitoring_network
      - production_app_network
      - production_db_network


  # Production MariaDB
  # Host Accessible at: http://localhost:$PRODUCTION_MARIADB_HOST_TCP_PORT
  # Docker Accessible at: http://localhost:$PRODUCTION_MARIADB_CONTAINER_TCP_PORT
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
      - "$PRODUCTION_MARIADB_HOST_TCP_PORT:$PRODUCTION_MARIADB_CONTAINER_TCP_PORT"
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
  # Host Accessible at: http://localhost:$PRODUCTION_NEO4J_HOST_HTTP_PORT
  # Docker Accessible at: http://localhost:$PRODUCTION_NEO4J_CONTAINER_HTTP_PORT
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
      - "$PRODUCTION_NEO4J_HOST_HTTP_PORT:$PRODUCTION_NEO4J_CONTAINER_HTTP_PORT"
      - "$PRODUCTION_NEO4J_HOST_BOLT_PORT:$PRODUCTION_NEO4J_CONTAINER_BOLT_PORT"
    healthcheck:
      test: ["CMD", "wget", "--no-verbose", "--tries=1", "--spider", "http://production_neo4j:$PRODUCTION_NEO4J_CONTAINER_HTTP_PORT/browser/"]
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
      - production_app_network
      - production_db_network


# Development Services

  # Development PHP-fpm Apache2
  # Host Accessible at: http://localhost:$DEVELOPMENT_PHPFPM_APACHE_HOST_HTTP_PORT
  # Docker Accessible at: http://localhost:$DEVELOPMENT_PHPFPM_APACHE_CONTAINER_HTTP_PORT
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
      - "$DEVELOPMENT_PHPFPM_APACHE_HOST_HTTP_PORT:$DEVELOPMENT_PHPFPM_APACHE_CONTAINER_HTTP_PORT"
      - "$DEVELOPMENT_PHPFPM_APACHE_HOST_HTTPS_PORT:$DEVELOPMENT_PHPFPM_APACHE_CONTAINER_HTTPS_PORT"
      - "$DEVELOPMENT_PHPFPM_APACHE_HOST_HTTPS_PORT:$DEVELOPMENT_PHPFPM_APACHE_CONTAINER_HTTPS_PORT/udp"
    healthcheck:
      test: ["CMD", "curl", "-f", "http://development_phpfpm_apache:$DEVELOPMENT_PHPFPM_APACHE_CONTAINER_HTTP_PORT/"]
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


  # Development Postgres
  # Host Accessible at: http://localhost:$DEVELOPMENT_POSTGRES_HOST_TCP_PORT
  # Docker Accessible at: http://localhost:$DEVELOPMENT_POSTGRES_CONTAINER_TCP_PORT
  # Healthcheck status: working

  development_postgres:
    container_name: development_postgres
    labels:
      - "local.service.name=Development - DB Server: Postgres"
      - "local.service.description=Development Postgres database server. Certain directories for this service are made available to the host machine for the purposes of data persistence."
      - "local.service.source.url=https://github.com/postgres/postgres"
      - "portainer.agent.stack=true"  
    <<: *common_postgres
    env_file:
      - $DEVELOPMENT_POSTGRES_ENVIRONMENT_FILE
    ports:
      - "$DEVELOPMENT_POSTGRES_HOST_TCP_PORT:$DEVELOPMENT_POSTGRES_CONTAINER_TCP_PORT"
    logging:
      <<: *default-logging
      options:
        tag: "development-database-postgres/{{.Name}}"
    volumes:
      - host_development_postgres_data_postgresql_volume:/var/lib/postgresql/data
    networks:
      - core_monitoring_network
      - development_app_network
      - development_db_network


  # Development MariaDB
  # Host Accessible at: http://localhost:$DEVELOPMENT_MARIADB_HOST_TCP_PORT
  # Docker Accessible at: http://localhost:$DEVELOPMENT_MARIADB_CONTAINER_TCP_PORT
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
      - "$DEVELOPMENT_MARIADB_HOST_TCP_PORT:$DEVELOPMENT_MARIADB_CONTAINER_TCP_PORT"
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
  # Host Accessible at: http://localhost:$DEVELOPMENT_NEO4J_HOST_HTTP_PORT
  # Docker Accessible at: http://localhost:$DEVELOPMENT_NEO4J_CONTAINER_HTTP_PORT
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
      - "$DEVELOPMENT_NEO4J_HOST_HTTP_PORT:$DEVELOPMENT_NEO4J_CONTAINER_HTTP_PORT"
      - "$DEVELOPMENT_NEO4J_HOST_BOLT_PORT:$DEVELOPMENT_NEO4J_CONTAINER_BOLT_PORT"
    healthcheck:
      test: ["CMD", "wget", "--no-verbose", "--tries=1", "--spider", "http://development_neo4j:$DEVELOPMENT_NEO4J_CONTAINER_HTTP_PORT/browser/"]
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
      - development_app_network
      - development_db_network

networks:
# Core Networks

  # Core Monitoring Network is used to monitor all of our services/docker containers ( Portainer and all other docker services )
  
  core_monitoring_network:
    driver: bridge


  # Core Remote Access Network is used for our remote access related services/docker containers ( In future updates Zrok, Caddy, Traefik )
  
  core_remote_access_network:
    driver: bridge
  
  
  # Core AI Network is used for our AI related services/docker containers ( SearxNG, Ollama, OpenWebUI )
 
  core_ai_network:
    driver: bridge


# Production Networks

  # Production App Network is used for our web application related services/docker containers ( PHP Apache2, Postgres, MariaDB, Neo4j, SearxNG, Ollama )
 
  production_app_network:
    driver: bridge
  
  
  # Production DB Network is used for our database related services/docker containers ( Postgres, MariaDB, Neo4j, PGAdmin, PHPMyAdmin )
  
  production_db_network:
    driver: bridge


# Development Networks

  # Development App Network is used for our web application related services/docker containers ( PHP Apache2, Postgres, MariaDB, Neo4j, SearxNG, Ollama )
  
  development_app_network:
    driver: bridge
  

  # Development DB Network is used for our database related services/docker containers ( Postgres, MariaDB, Neo4j, PGAdmin, PHPMyAdmin )
  
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
  local user_id="${2:-$CURRENT_UID}"
  local group_id="${3:-$CURRENT_GID}"
  
  echo "Fixing permissions for $path..."
  if [ -d "$path" ]; then
    sudo chown -R $user_id:$group_id "$path"
    echo "Set ownership to $user_id:$group_id for $path"
  else
    echo "Warning: Directory $path does not exist"
  fi
}

# Fix permissions for all data directories
echo "Fixing permissions for data directories..."
for dir in $HOME/.docker/*/data/*; do
  if [ -d "$dir" ]; then
    # Special handling for pgadmin directories
    echo "Checking directory: $dir"
    if [[ "$dir" != *"/pgadmin"* ]]; then      
      fix_permissions "$dir"
    fi
  fi
done

generate_secrets
create_docker_configs

log "Project setup complete!"
log "To start the project, run: docker-compose up -d --build"
