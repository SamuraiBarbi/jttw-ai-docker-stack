#!/bin/bash

# Color codes for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

TIMEZONE="TZ=America/New_York"
SERVICE_PORTAINER_VERSION="2.21.4"
SERVICE_SEARXNG_VERSION="2024.12.16-65c970bdf"
SERVICE_PGADMIN_VERSION="8.14.0"
SERVICE_PHPMYADMIN_VERSION="5.2.1"
SERVICE_LLAMACPP_VERSION="server-cuda-b4677"
SERVICE_OLLAMA_VERSION="0.5.1"
SERVICE_OPENWEBUI_VERSION="git-feffdf1"
SERVICE_KOKORO_TTS_VERSION="v0.1.4"
SERVICE_GPTSOVITS_TTS_VERSION="dev-e80abbc"
SERVICE_F5_TTS_VERSION="main"
SERVICE_PHPFPM_APACHE_VERSION="php8"
SERVICE_POSTGRES_VERSION="12.22"
SERVICE_MARIADB_VERSION="10.6"
SERVICE_NEO4J_VERSION="5.26.0-community"

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
# Ports 9000-9099: Management UIs
CORE_PORTAINER_DATA_PATH="$CORE_DATA_PATH/portainer"
CORE_PORTAINER_ENVIRONMENT_FILE="$CORE_SECRETS_PATH/.portainer.env"
CORE_PORTAINER_HOST_HTTP_PORT=9000
CORE_PORTAINER_CONTAINER_HTTP_PORT=9000

CORE_PGADMIN_DATA_PATH="$CORE_DATA_PATH/pgadmin"
CORE_PGADMIN_ENVIRONMENT_FILE="$CORE_SECRETS_PATH/.pgadmin.env"
CORE_PGADMIN_HOST_HTTP_PORT=9001
CORE_PGADMIN_CONTAINER_HTTP_PORT=80

CORE_PHPMYADMIN_DATA_PATH="$CORE_DATA_PATH/phpmyadmin"
CORE_PHPMYADMIN_ENVIRONMENT_FILE="$CORE_SECRETS_PATH/.phpmyadmin.env"
CORE_PHPMYADMIN_HOST_HTTP_PORT=9002
CORE_PHPMYADMIN_CONTAINER_HTTP_PORT=80

# Ports 9100-9199: Search/AI
CORE_SEARXNG_DATA_PATH="$CORE_DATA_PATH/searxng"
CORE_SEARXNG_ENVIRONMENT_FILE="$CORE_SECRETS_PATH/.searxng.env"
CORE_SEARXNG_HOST_HTTP_PORT=9100
CORE_SEARXNG_CONTAINER_HTTP_PORT=8080

CORE_LLAMACPP_DATA_PATH="$CORE_DATA_PATH/llamacpp"
CORE_LLAMACPP_ENVIRONMENT_FILE="$CORE_SECRETS_PATH/.llamacpp.env"
CORE_LLAMACPP_HOST_HTTP_PORT=9110
CORE_LLAMACPP_CONTAINER_HTTP_PORT=8080

CORE_OLLAMA_DATA_PATH="$CORE_DATA_PATH/ollama"
CORE_OLLAMA_ENVIRONMENT_FILE="$CORE_SECRETS_PATH/.ollama.env"
CORE_OLLAMA_HOST_HTTP_PORT=9111
CORE_OLLAMA_CONTAINER_HTTP_PORT=11434

CORE_OPENWEBUI_DATA_PATH="$CORE_DATA_PATH/openwebui"
CORE_OPENWEBUI_ENVIRONMENT_FILE="$CORE_SECRETS_PATH/.openwebui.env"
CORE_OPENWEBUI_HOST_HTTP_PORT=9120
CORE_OPENWEBUI_CONTAINER_HTTP_PORT=8080

# Ports 9200-9299: TTS Services
CORE_KOKORO_TTS_DATA_PATH="$CORE_DATA_PATH/kokoro_tts"
CORE_KOKORO_TTS_ENVIRONMENT_FILE="$CORE_SECRETS_PATH/.kokoro_tts.env"
CORE_KOKORO_TTS_HOST_HTTP_PORT=9200
CORE_KOKORO_TTS_CONTAINER_HTTP_PORT=8880

CORE_GPTSOVITS_TTS_DATA_PATH="$CORE_DATA_PATH/gptsovits_tts"
CORE_GPTSOVITS_TTS_ENVIRONMENT_FILE="$CORE_SECRETS_PATH/.gptsovits_tts.env"
CORE_GPTSOVITS_TTS_HOST_HTTP_PORT=9202
CORE_GPTSOVITS_TTS_CONTAINER_HTTP_PORT=9880
CORE_GPTSOVITS_WEBUI_HOST_HTTP_PORT=9203
CORE_GPTSOVITS_WEBUI_CONTAINER_HTTP_PORT=9872

CORE_F5_TTS_DATA_PATH="$CORE_DATA_PATH/f5_tts"
CORE_F5_TTS_ENVIRONMENT_FILE="$CORE_SECRETS_PATH/.f5_tts.env"
CORE_F5_TTS_HOST_HTTP_PORT=9205
CORE_F5_TTS_CONTAINER_HTTP_PORT=7860


# Define production service data path and environment file variables
# Ports 10000-10099: Production Web Services
PRODUCTION_PHPFPM_APACHE_DATA_PATH="$PRODUCTION_DATA_PATH/phpfpm_apache"
PRODUCTION_PHPFPM_APACHE_ENVIRONMENT_FILE="$PRODUCTION_SECRETS_PATH/.phpfpm_apache.env" 
PRODUCTION_PHPFPM_APACHE_HOST_HTTP_PORT=10000
PRODUCTION_PHPFPM_APACHE_CONTAINER_HTTP_PORT=80
PRODUCTION_PHPFPM_APACHE_HOST_HTTPS_PORT=10001
PRODUCTION_PHPFPM_APACHE_CONTAINER_HTTPS_PORT=443

# Ports 10100-10199: Production Databases Services
PRODUCTION_POSTGRES_DATA_PATH="$PRODUCTION_DATA_PATH/postgres"
PRODUCTION_POSTGRES_ENVIRONMENT_FILE="$PRODUCTION_SECRETS_PATH/.postgres.env"
PRODUCTION_POSTGRES_HOST_TCP_PORT=10100
PRODUCTION_POSTGRES_CONTAINER_TCP_PORT=5432

PRODUCTION_MARIADB_DATA_PATH="$PRODUCTION_DATA_PATH/mariadb"
PRODUCTION_MARIADB_ENVIRONMENT_FILE="$PRODUCTION_SECRETS_PATH/.mariadb.env"
PRODUCTION_MARIADB_HOST_TCP_PORT=10101
PRODUCTION_MARIADB_CONTAINER_TCP_PORT=3306

PRODUCTION_NEO4J_DATA_PATH="$PRODUCTION_DATA_PATH/neo4j"
PRODUCTION_NEO4J_ENVIRONMENT_FILE="$PRODUCTION_SECRETS_PATH/.neo4j.env"
PRODUCTION_NEO4J_HOST_HTTP_PORT=10102
PRODUCTION_NEO4J_CONTAINER_HTTP_PORT=7474
PRODUCTION_NEO4J_HOST_BOLT_PORT=10103
PRODUCTION_NEO4J_CONTAINER_BOLT_PORT=7687

# Define development service data path and environment file variables
# Ports 20000-20099: Development Web Services
DEVELOPMENT_PHPFPM_APACHE_DATA_PATH="$DEVELOPMENT_DATA_PATH/phpfpm_apache"
DEVELOPMENT_PHPFPM_APACHE_ENVIRONMENT_FILE="$DEVELOPMENT_SECRETS_PATH/.phpfpm_apache.env"
DEVELOPMENT_PHPFPM_APACHE_HOST_HTTP_PORT=20000
DEVELOPMENT_PHPFPM_APACHE_CONTAINER_HTTP_PORT=80
DEVELOPMENT_PHPFPM_APACHE_HOST_HTTPS_PORT=20001
DEVELOPMENT_PHPFPM_APACHE_CONTAINER_HTTPS_PORT=443

# Ports 20100-20199: Development Databases Services
DEVELOPMENT_POSTGRES_DATA_PATH="$DEVELOPMENT_DATA_PATH/postgres"
DEVELOPMENT_POSTGRES_ENVIRONMENT_FILE="$DEVELOPMENT_SECRETS_PATH/.postgres.env"
DEVELOPMENT_POSTGRES_HOST_TCP_PORT=20100
DEVELOPMENT_POSTGRES_CONTAINER_TCP_PORT=5432

DEVELOPMENT_MARIADB_DATA_PATH="$DEVELOPMENT_DATA_PATH/mariadb"
DEVELOPMENT_MARIADB_ENVIRONMENT_FILE="$DEVELOPMENT_SECRETS_PATH/.mariadb.env"
DEVELOPMENT_MARIADB_HOST_TCP_PORT=20101
DEVELOPMENT_MARIADB_CONTAINER_TCP_PORT=3306

DEVELOPMENT_NEO4J_DATA_PATH="$DEVELOPMENT_DATA_PATH/neo4j"
DEVELOPMENT_NEO4J_ENVIRONMENT_FILE="$DEVELOPMENT_SECRETS_PATH/.neo4j.env"
DEVELOPMENT_NEO4J_HOST_HTTP_PORT=20102
DEVELOPMENT_NEO4J_CONTAINER_HTTP_PORT=7474
DEVELOPMENT_NEO4J_HOST_BOLT_PORT=20103
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
  sudo -u $USER mkdir -p $CORE_DATA_PATH/{portainer,pgadmin,phpmyadmin,searxng,llamacpp,ollama,openwebui,kokoro_tts,gptsovits_tts,f5_tts} || error "Failed to create core service directories."
  sudo -u $USER mkdir -p $CORE_PGADMIN_DATA_PATH/storage_pgadmin || error "Failed to create core PGAdmin directories."
  sudo -u $USER mkdir -p $CORE_LLAMACPP_DATA_PATH/data_models || error "Failed to create core Llama directories."
  sudo -u $USER mkdir -p $CORE_OLLAMA_DATA_PATH/{data_models,data_config} || error "Failed to create core Ollama directories."
  sudo -u $USER mkdir -p $CORE_KOKORO_TTS_DATA_PATH/{data_src,data_models,data_ui} || error "Failed to create core Kokoro TTS directories."

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
    echo "TZ=$TIMEZONE" >> $CORE_PORTAINER_ENVIRONMENT_FILE || error "Failed to write TZ to core .portainer.env."
  fi

  if [ ! -f "$CORE_PGADMIN_ENVIRONMENT_FILE" ]; then
    sudo -u $USER touch $CORE_PGADMIN_ENVIRONMENT_FILE || error "Failed to create core .pgadmin.env."
    echo "PGADMIN_DEFAULT_EMAIL=pgadmin@jttw-ai-docker-stack.com" > $CORE_PGADMIN_ENVIRONMENT_FILE || error "Failed to write PGADMIN_DEFAULT_EMAIL to core .pgadmin.env."
    echo "PGADMIN_DEFAULT_PASSWORD=$(generate_random_string)" >> $CORE_PGADMIN_ENVIRONMENT_FILE || error "Failed to write PGADMIN_DEFAULT_PASSWORD to core .pgadmin.env."
    echo "MASTER_PASSWORD_REQUIRED=False" >> $CORE_PGADMIN_ENVIRONMENT_FILE || error "Failed to write MASTER_PASSWORD_REQUIRED to core .pgadmin.env."
    echo "TZ=$TIMEZONE" >> $CORE_PGADMIN_ENVIRONMENT_FILE || error "Failed to write TZ to core .pgadmin.env."
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

  if [ ! -f "$CORE_SEARXNG_ENVIRONMENT_FILE" ]; then
    sudo -u $USER touch $CORE_SEARXNG_ENVIRONMENT_FILE || error "Failed to create core .searxng.env."
    echo "SEARXNG_BASE_URL=http://localhost:$CORE_SEARXNG_HOST_HTTP_PORT" > $CORE_SEARXNG_ENVIRONMENT_FILE || error "Failed to write BASE_URL to core .searxng.env."
    echo "INSTANCE_NAME=JTTW SearxNG" >> $CORE_SEARXNG_ENVIRONMENT_FILE || error "Failed to write INSTANCE_NAME to core .searxng.env."
    echo "UWSGI_WORKERS=4" >> $CORE_SEARXNG_ENVIRONMENT_FILE || error "Failed to write UWSGI_WORKERS to core .searxng.env."
    echo "UWSGI_THREADS=4" >> $CORE_SEARXNG_ENVIRONMENT_FILE || error "Failed to write UWSGI_THREADS to core .searxng.env."
    echo "SEARXNG_SEARCH_FORMATS=html,json" >> $CORE_SEARXNG_ENVIRONMENT_FILE || error "Failed to write SEARXNG_SETTINGS_SEARCH__FORMATS to core .searxng.env."
    echo "SEARXNG_SEARCH_DEFAULT_FORMAT=html" >> $CORE_SEARXNG_ENVIRONMENT_FILE || error "Failed to write SEARXNG_SETTINGS_SEARCH__DEFAULT_FORMAT to core .searxng.env."
    echo "TZ=$TIMEZONE" >> $CORE_SEARXNG_ENVIRONMENT_FILE || error "Failed to write TZ to core .searxng.env."
  fi  

  if [ ! -f "$CORE_LLAMACPP_ENVIRONMENT_FILE" ]; then
    sudo -u $USER touch $CORE_LLAMACPP_ENVIRONMENT_FILE || error "Failed to create core .llamacpp.env."
    echo "LLAMA_CUDA=1" > $CORE_LLAMACPP_ENVIRONMENT_FILE || error "Failed to write LLAMA_CUDA to core .llamacpp.env."
    echo "LLAMA_CURL=1" >> $CORE_LLAMACPP_ENVIRONMENT_FILE || error "Failed to write LLAMA_CURL to core .llamacpp.env."
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
    echo "SEARXNG_QUERY_URL=http://core_searxng:$CORE_SEARXNG_CONTAINER_HTTP_PORT/search?q=<query>&format=json" >> $CORE_OPENWEBUI_ENVIRONMENT_FILE || error "Failed to write SEARXNG_QUERY_URL to core .openwebui.env."
    echo "RAG_WEB_SEARCH_RESULT_COUNT=5" >> $CORE_OPENWEBUI_ENVIRONMENT_FILE || error "Failed to write RAG_WEB_SEARCH_RESULT_COUNT to core .openwebui.env."
    echo "RAG_WEB_SEARCH_CONCURRENT_REQUESTS=10" >> $CORE_OPENWEBUI_ENVIRONMENT_FILE || error "Failed to write RAG_WEB_SEARCH_CONCURRENT_REQUESTS to core .openwebui.env."
    echo "AUDIO_TTS_ENGINE=openai" >> $CORE_OPENWEBUI_ENVIRONMENT_FILE || error "Failed to write AUDIO_TTS_ENGINE to core .openwebui.env."
    echo "AUDIO_TTS_OPENAI_API_BASE_URL=http://core_kokoro_tts:$CORE_KOKORO_TTS_CONTAINER_HTTP_PORT/v1" >> $CORE_OPENWEBUI_ENVIRONMENT_FILE || error "Failed to write AUDIO_TTS_OPENAI_API_BASE_URL to core .openwebui.env."
    echo "AUDIO_TTS_OPENAI_API_KEY=key-to-success" >> $CORE_OPENWEBUI_ENVIRONMENT_FILE || error "Failed to write AUDIO_TTS_API_KEY to core .openwebui.env."
    echo "AUDIO_TTS_MODEL=kokoro" >> $CORE_OPENWEBUI_ENVIRONMENT_FILE || error "Failed to write AUDIO_TTS_MODEL to core .openwebui.env."
    echo "AUDIO_TTS_VOICE=bf_emma" >> $CORE_OPENWEBUI_ENVIRONMENT_FILE || error "Failed to write AUDIO_TTS_VOICE to core .openwebui.env."
    echo "AUDIO_TTS_SPLIT_ON=punctuation" >> $CORE_OPENWEBUI_ENVIRONMENT_FILE || error "Failed to write AUDIO_TTS_SPLIT_ON to core .openwebui.env."    
  fi

  if [ ! -f "$CORE_KOKORO_TTS_ENVIRONMENT_FILE" ]; then
    sudo -u $USER touch $CORE_KOKORO_TTS_ENVIRONMENT_FILE || error "Failed to create core .kokoro_tts.env."
    echo "PYTHONUNBUFFERED=1" > $CORE_KOKORO_TTS_ENVIRONMENT_FILE || error "Failed to write PYTHONUNBUFFERED to core .kokoro_tts.env."
    echo "PYTHONPATH=/app:/app/api:/app/Kokoro-82M" >> $CORE_KOKORO_TTS_ENVIRONMENT_FILE || error "Failed to write PYTHONPATH to core .kokoro_tts.env."
    echo "PATH=/home/appuser/.local/bin:/app/.venv/bin:\$PATH" >> $CORE_KOKORO_TTS_ENVIRONMENT_FILE || error "Failed to write PATH to core .kokoro_tts.env."    
    echo "GRADIO_WATCH=True" >> $CORE_KOKORO_TTS_ENVIRONMENT_FILE || error "Failed to write GRADIO_WATCH to core .kokoro_tts.env."
    echo "USE_GPU=true" >> $CORE_KOKORO_TTS_ENVIRONMENT_FILE || error "Failed to write USE_GPU to core .kokoro_tts.env."
    echo "USE_ONNX=false" >> $CORE_KOKORO_TTS_ENVIRONMENT_FILE || error "Failed to write USE_ONNX to core .kokoro_tts.env."
    echo "DOWNLOAD_PTH=true" >> $CORE_KOKORO_TTS_ENVIRONMENT_FILE || error "Failed to write DOWNLOAD_PTH to core .kokoro_tts.env."
    echo "DOWNLOAD_ONNX=false" >> $CORE_KOKORO_TTS_ENVIRONMENT_FILE || error "Failed to write DOWNLOAD_ONNX to core .kokoro_tts.env."
  fi

  if [ ! -f "$CORE_GPTSOVITS_TTS_ENVIRONMENT_FILE" ]; then
    sudo -u $USER touch $CORE_GPTSOVITS_TTS_ENVIRONMENT_FILE || error "Failed to create core .gptsovits_tts.env."
    echo "PATH=/home/appuser/.local/bin:\$PATH" >> $CORE_GPTSOVITS_TTS_ENVIRONMENT_FILE || error "Failed to write PATH to core .gptsovits_tts.env."
    echo "PYTHONPATH=/workspace" >> $CORE_GPTSOVITS_TTS_ENVIRONMENT_FILE || error "Failed to write PYTHONPATH to core .gptsovits_tts.env."
    echo "is_half=False" >> $CORE_GPTSOVITS_TTS_ENVIRONMENT_FILE || error "Failed to write is_half to core .gptsovits_tts.env."
    echo "is_share=False" >> $CORE_GPTSOVITS_TTS_ENVIRONMENT_FILE || error "Failed to write is_share to core .gptsovits_tts.env."
    echo "DEBIAN_FRONTEND=noninteractive" >> $CORE_GPTSOVITS_TTS_ENVIRONMENT_FILE || error "Failed to write DEBIAN_FRONTEND to core .gptsovits_tts.env."
    # echo "TZ=America/New_York" >> $CORE_GPTSOVITS_TTS_ENVIRONMENT_FILE || error "Failed to write TZ to core .gptsovits_tts.env."
  fi

  if [ ! -f "$CORE_F5_TTS_ENVIRONMENT_FILE" ]; then
    sudo -u $USER touch $CORE_F5_TTS_ENVIRONMENT_FILE || error "Failed to create core .f5_tts.env."
    echo "PYTHONPATH=/workspace:/workspace/F5-TTS" >> $CORE_F5_TTS_ENVIRONMENT_FILE || error "Failed to write PYTHONPATH to core .f5_tts.env."
  fi

  # Production secrets
  if [ ! -f "$PRODUCTION_PHPFPM_APACHE_ENVIRONMENT_FILE" ]; then
    sudo -u $USER touch $PRODUCTION_PHPFPM_APACHE_ENVIRONMENT_FILE || error "Failed to create production .phpfpm_apache.env."
    echo "PHP_FPM_PASSWORD=$(generate_random_string)" > $PRODUCTION_PHPFPM_APACHE_ENVIRONMENT_FILE || error "Failed to write PHP_FPM_PASSWORD to production .phpfpm_apache.env."
    echo "APACHE2_PASSWORD=$(generate_random_string)" >> $PRODUCTION_PHPFPM_APACHE_ENVIRONMENT_FILE || error "Failed to write APACHE2_PASSWORD to production .phpfpm_apache.env."     
  fi

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
    echo "NEO4J_PLUGINS=[\"apoc\"]" >> $PRODUCTION_NEO4J_ENVIRONMENT_FILE || error "Failed to write NEO4J_PLUGINS to production .neo4j.env."
    echo "NEO4J_apoc_export_file_enabled=true" >> $PRODUCTION_NEO4J_ENVIRONMENT_FILE || error "Failed to write NEO4J_apoc_export_file_enabled to production .neo4j.env."
    echo "NEO4J_apoc_import_file_enabled=true" >> $PRODUCTION_NEO4J_ENVIRONMENT_FILE || error "Failed to write NEO4J_apoc_import_file_enabled to production .neo4j.env."
    echo "NEO4J_apoc_import_file_use__neo4j__config=true" >> $PRODUCTION_NEO4J_ENVIRONMENT_FILE || error "Failed to write NEO4J_apoc_import_file_use__neo4j__config to production .neo4j.env."
    echo "NEO4JLABS_PLUGINS=[\"apoc\"]" >> $PRODUCTION_NEO4J_ENVIRONMENT_FILE || error "Failed to write NEO4JLABS_PLUGINS to production .neo4j.env."
  fi

  # Development secrets
  if [ ! -f "$DEVELOPMENT_PHPFPM_APACHE_ENVIRONMENT_FILE" ]; then
    sudo -u $USER touch $DEVELOPMENT_PHPFPM_APACHE_ENVIRONMENT_FILE || error "Failed to create development .phpfpm_apache.env."
    echo "PHP_FPM_PASSWORD=$(generate_random_string)" > $DEVELOPMENT_PHPFPM_APACHE_ENVIRONMENT_FILE || error "Failed to write PHP_FPM_PASSWORD to development .phpfpm_apache.env."
    echo "APACHE2_PASSWORD=$(generate_random_string)" >> $DEVELOPMENT_PHPFPM_APACHE_ENVIRONMENT_FILE || error "Failed to write APACHE2_PASSWORD to development .phpfpm_apache.env."      
  fi

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
    echo "NEO4J_PLUGINS=[\"apoc\"]" >> $DEVELOPMENT_NEO4J_ENVIRONMENT_FILE || error "Failed to write NEO4J_PLUGINS to development .neo4j.env."
    echo "NEO4J_apoc_export_file_enabled=true" >> $DEVELOPMENT_NEO4J_ENVIRONMENT_FILE || error "Failed to write NEO4J_apoc_export_file_enabled to development .neo4j.env."
    echo "NEO4J_apoc_import_file_enabled=true" >> $DEVELOPMENT_NEO4J_ENVIRONMENT_FILE || error "Failed to write NEO4J_apoc_import_file_enabled to development .neo4j.env."
    echo "NEO4J_apoc_import_file_use__neo4j__config=true" >> $DEVELOPMENT_NEO4J_ENVIRONMENT_FILE || error "Failed to write NEO4J_apoc_import_file_use__neo4j__config to development .neo4j.env."
    echo "NEO4JLABS_PLUGINS=[\"apoc\"]" >> $DEVELOPMENT_NEO4J_ENVIRONMENT_FILE || error "Failed to write NEO4JLABS_PLUGINS to development .neo4j.env."
  fi


  # Set specific permissions for secrets directories
  sudo -u $USER chmod -R 700 $BASE_PATH/*/secrets/ || error "Failed to set permissions for secrets directories."

  log "Secrets generated and stored successfully"
}

# Create Docker configuration files
create_docker_configs() {
  log "Creating Docker configuration files..."

  cat > docker-compose.yml << EOF
# To stop all of the containers, run: sudo -S docker compose down --remove-orphans
# To stop a specific container, run: sudo -S docker compose stop core_f5_tts
# To remove the containers, run: sudo -S docker compose down --remove-orphans && sudo -S docker system prune -af
# To list the containers, run: sudo -S docker ps -a && echo '=== Images ===' && echo darkness | sudo -S docker images && echo '=== Networks ===' && echo darkness | sudo -S docker network ls
# To remove all persisted volume data, run: sudo rm -rf ${BASE_PATH}
# To rebuild the project, run: cd \$HOME/Documents/projects/jttw-ai-docker-stack && bash setup.sh
# To start the project, run: cd \$HOME/Documents/projects/jttw-ai-docker-stack && sudo -S docker compose up -d
# Example to get a docker containers logs: docker logs production_mariadb
# Example to execute a command in a container: docker exec core_ollama ollama list

volumes:
# Core volumes

  host_core_storage_volume:
    driver: local
    driver_opts:
      type: none
      device: ${CORE_PATH}/
      o: bind    
  host_core_secrets_volume:
    driver: local
    driver_opts:
      type: none
      device: ${CORE_SECRETS_PATH}/
      o: bind
  host_core_portainer_storage_volume:
    driver: local
    driver_opts:
      type: none
      device: ${CORE_PORTAINER_DATA_PATH}/
      o: bind
  host_core_pgadmin_storage_volume:
    driver: local
    driver_opts:
      type: none
      device: ${CORE_PGADMIN_DATA_PATH}/storage_pgadmin/
      o: bind            
  host_core_phpmyadmin_storage_volume:
    driver: local
    driver_opts:
      type: none
      device: ${CORE_PHPMYADMIN_DATA_PATH}/
      o: bind
  host_core_searxng_storage_volume:
    driver: local
    driver_opts:
      type: none
      device: ${CORE_SEARXNG_DATA_PATH}/
      o: bind    
  host_core_llamacpp_data_models_volume:
    driver: local
    driver_opts:
      type: none
      device: ${CORE_LLAMACPP_DATA_PATH}/data_models/
      o: bind  
  host_core_ollama_data_models_volume:
    driver: local
    driver_opts:
      type: none
      device: ${CORE_OLLAMA_DATA_PATH}/data_models/
      o: bind
  host_core_ollama_data_config_volume:
    driver: local
    driver_opts:
      type: none
      device: ${CORE_OLLAMA_DATA_PATH}/data_config/
      o: bind  
  host_core_openwebui_storage_volume:
    driver: local
    driver_opts:
      type: none
      device: ${CORE_OPENWEBUI_DATA_PATH}/
      o: bind      
  host_core_kokoro_tts_data_src_volume:
    driver: local
    driver_opts:
      type: none
      device: ${CORE_KOKORO_TTS_DATA_PATH}/data_src/
      o: bind    
  host_core_kokoro_tts_data_models_volume:
    driver: local
    driver_opts:
      type: none
      device: ${CORE_KOKORO_TTS_DATA_PATH}/data_models/
      o: bind 
  host_core_kokoro_tts_data_ui_volume:
    driver: local
    driver_opts:
      type: none
      device: ${CORE_KOKORO_TTS_DATA_PATH}/data_ui/
      o: bind 
  host_core_gptsovits_tts_storage_volume:
    driver: local
    driver_opts:
      type: none
      device: ${CORE_GPTSOVITS_TTS_DATA_PATH}/
      o: bind
  host_core_f5_tts_storage_volume:
    driver: local
    driver_opts:
      type: none
      device: ${CORE_F5_TTS_DATA_PATH}/
      o: bind


# Production volumes

  host_production_secrets_volume:
    driver: local
    driver_opts:
      type: none
      device: ${PRODUCTION_SECRETS_PATH}/
      o: bind   
  host_production_phpfpm_apache_data_apache_volume:
    driver: local
    driver_opts:
      type: none
      device: ${PRODUCTION_PHPFPM_APACHE_DATA_PATH}/data_apache/
      o: bind
  host_production_phpfpm_apache_config_php_volume:
    driver: local
    driver_opts:
      type: none
      device: ${PRODUCTION_PHPFPM_APACHE_DATA_PATH}/config_php/
      o: bind    
  host_production_phpfpm_apache_config_apache_volume:
    driver: local
    driver_opts:
      type: none
      device: ${PRODUCTION_PHPFPM_APACHE_DATA_PATH}/config_apache/
      o: bind    
  host_production_postgres_data_postgresql_volume:
    driver: local
    driver_opts:
      type: none
      device: ${PRODUCTION_POSTGRES_DATA_PATH}/data_postgresql/
      o: bind   
  host_production_mariadb_data_mysql_volume:
    driver: local
    driver_opts:
      type: none
      device: ${PRODUCTION_MARIADB_DATA_PATH}/data_mysql/
      o: bind
  host_production_neo4j_data_volume:
    driver: local
    driver_opts:
      type: none
      device: ${PRODUCTION_NEO4J_DATA_PATH}/data/
      o: bind
  host_production_neo4j_logs_volume:
    driver: local
    driver_opts:
      type: none
      device: ${PRODUCTION_NEO4J_DATA_PATH}/logs/
      o: bind

# Development volumes

  host_development_secrets_volume:
    driver: local
    driver_opts:
      type: none
      device: ${DEVELOPMENT_SECRETS_PATH}/
      o: bind 
  host_development_phpfpm_apache_data_apache_volume:
    driver: local
    driver_opts:
      type: none
      device: ${DEVELOPMENT_PHPFPM_APACHE_DATA_PATH}/data_apache/
      o: bind
  host_development_phpfpm_apache_config_php_volume:
    driver: local
    driver_opts:
      type: none
      device: ${DEVELOPMENT_PHPFPM_APACHE_DATA_PATH}/config_php/
      o: bind    
  host_development_phpfpm_apache_config_apache_volume:
    driver: local
    driver_opts:
      type: none
      device: ${DEVELOPMENT_PHPFPM_APACHE_DATA_PATH}/config_apache/
      o: bind   
  host_development_postgres_data_postgresql_volume:
    driver: local
    driver_opts:
      type: none
      device: ${DEVELOPMENT_POSTGRES_DATA_PATH}/data_postgresql/
      o: bind 
  host_development_mariadb_data_mysql_volume:
    driver: local
    driver_opts:
      type: none
      device: ${DEVELOPMENT_MARIADB_DATA_PATH}/data_mysql/
      o: bind
  host_development_neo4j_data_volume:
    driver: local
    driver_opts:
      type: none
      device: ${DEVELOPMENT_NEO4J_DATA_PATH}/data/
      o: bind
  host_development_neo4j_logs_volume:
    driver: local
    driver_opts:
      type: none
      device: ${DEVELOPMENT_NEO4J_DATA_PATH}/logs/
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
  image: shinsenter/phpfpm-apache:${SERVICE_PHPFPM_APACHE_VERSION}
  restart: unless-stopped 
  deploy:
    resources:
      limits:
        cpus: '0.50'
        memory: 512M

x-common_postgres: &common_postgres
  image: postgres:${SERVICE_POSTGRES_VERSION}
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
  image: mariadb:${SERVICE_MARIADB_VERSION}
  restart: unless-stopped
  deploy:
    resources:
      limits:
        cpus: '1.0'
        memory: 1G

x-common_neo4j: &common_neo4j
  image: neo4j:${SERVICE_NEO4J_VERSION}
  restart: unless-stopped
  depends_on:
    core_llamacpp:
      condition: service_healthy
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
            "Port": ${PRODUCTION_POSTGRES_CONTAINER_TCP_PORT},
            "MaintenanceDB": "postgres",
            "Username": "production_user",
            "SSLMode": "prefer"
          },
          "2": {
            "Name": "Development PostgreSQL",
            "Group": "Servers",
            "Host": "development_postgres",
            "Port": ${DEVELOPMENT_POSTGRES_CONTAINER_TCP_PORT},
            "MaintenanceDB": "postgres",
            "Username": "development_user",
            "SSLMode": "prefer"
          }
        }
      }
      

services:
# Core Services

  # Core Portainer Service
  # Host Accessible at: http://localhost:${CORE_PORTAINER_HOST_HTTP_PORT}
  # Docker Accessible at: http://localhost:${CORE_PORTAINER_CONTAINER_HTTP_PORT}
  # Healthcheck status: Not sure how to healthcheck Portainer because it lacks bash and shell. http://core_portainer:$CORE_PORTAINER_HOST_HTTP_PORT/api/system/status would be the best
  
  core_portainer:
    container_name: core_portainer
    image: portainer/portainer-ce:${SERVICE_PORTAINER_VERSION}
    labels:
      - "local.service.name=Core - Docker Web UI: Portainer"
      - "local.service.description=Core Portainer provides a web-based UI for managing Docker containers."
      - "local.service.source.url=https://github.com/portainer/portainer"
      - "portainer.agent.stack=true"
    restart: unless-stopped
    env_file:
      - ${CORE_PORTAINER_ENVIRONMENT_FILE}
    ports:
      - "${CORE_PORTAINER_HOST_HTTP_PORT}:${CORE_PORTAINER_CONTAINER_HTTP_PORT}"
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


  # Core PGAdmin Service
  # Host Accessible at: http://localhost:${CORE_PGADMIN_HOST_HTTP_PORT}
  # Docker Accessible at: http://localhost:${CORE_PGADMIN_CONTAINER_HTTP_PORT}
  # Healthcheck status: working

  core_pgadmin:
    container_name: core_pgadmin
    image: dpage/pgadmin4:${SERVICE_PGADMIN_VERSION}
    restart: unless-stopped
    labels:
      - "local.service.name=CORE - DB Web UI: PGAdmin"
      - "local.service.description=Core PGAdmin database web ui for Postgres. Certain directories for this service are made available to the host machine for the purposes of data persistence."
      - "local.service.source.url=https://github.com/pgadmin-org/pgadmin4"
      - "portainer.agent.stack=true"
    env_file:
      - ${CORE_PGADMIN_ENVIRONMENT_FILE}
    ports:
      - "${CORE_PGADMIN_HOST_HTTP_PORT}:${CORE_PGADMIN_CONTAINER_HTTP_PORT}"  
    healthcheck:
      test: ["CMD", "wget", "-q", "http://core_pgadmin:${CORE_PGADMIN_CONTAINER_HTTP_PORT}/", "-O", "/dev/null"]
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
  # Host Accessible at: http://localhost:${CORE_PHPMYADMIN_HOST_HTTP_PORT}
  # Docker Accessible at: http://localhost:${CORE_PHPMYADMIN_CONTAINER_HTTP_PORT}
  # Healthcheck status: working

  core_phpmyadmin:
    container_name: core_phpmyadmin
    image: phpmyadmin/phpmyadmin:${SERVICE_PHPMYADMIN_VERSION}
    restart: unless-stopped
    labels:
      - "local.service.name=CORE - DB Web UI: PHPMyAdmin"
      - "local.service.description=Core PHPMyAdmin database web ui for MariaDB. Certain directories for this service are made available to the host machine for the purposes of data persistence."
      - "local.service.source.url=https://github.com/phpmyadmin/phpmyadmin"
      - "portainer.agent.stack=true"    
    env_file:
      - ${CORE_PHPMYADMIN_ENVIRONMENT_FILE}
    ports:
      - "${CORE_PHPMYADMIN_HOST_HTTP_PORT}:${CORE_PHPMYADMIN_CONTAINER_HTTP_PORT}"  
    healthcheck:
      test: ["CMD", "curl", "-f", "http://core_phpmyadmin:${CORE_PHPMYADMIN_CONTAINER_HTTP_PORT}/"]
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


  # Core SearxNG Service
  ## Host Accessible at: http://localhost:${CORE_SEARXNG_HOST_HTTP_PORT}
  # Docker Accessible at: http://localhost:${CORE_SEARXNG_CONTAINER_HTTP_PORT}
  # Healthcheck status: working

  core_searxng:
    container_name: core_searxng
    image: searxng/searxng:${SERVICE_SEARXNG_VERSION}
    restart: unless-stopped
    user: "${HOST_USER_UID}:${HOST_USER_GID}"
    labels:
      - "local.service.name=Core - Search Engine: SearxNG"
      - "local.service.description=Core SearxNG search engine for searching the web. Certain directories for this service are made available to the host machine for the purposes of data persistence."
      - "local.service.source.url=https://github.com/searxng/searxng"
      - "portainer.agent.stack=true"  
    env_file:
      - ${CORE_SEARXNG_ENVIRONMENT_FILE}     
    ports:
      - "${CORE_SEARXNG_HOST_HTTP_PORT}:${CORE_SEARXNG_CONTAINER_HTTP_PORT}" 
    healthcheck:
      test: ["CMD", "wget", "--no-verbose", "--tries=1", "--spider", "http://core_searxng:${CORE_SEARXNG_CONTAINER_HTTP_PORT}/"]
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


  # Core Llama.cpp Service
  # Host Accessible at: http://localhost:${CORE_LLAMACPP_HOST_HTTP_PORT}
  # Docker Accessible at: http://localhost:${CORE_LLAMACPP_CONTAINER_HTTP_PORT}
  # Healthcheck status: working

  core_llamacpp:
    container_name: core_llamacpp
    image:  ghcr.io/ggerganov/llama.cpp:${SERVICE_LLAMACPP_VERSION}
    restart: unless-stopped
    labels:
      - "local.service.name=Core - LLM Server: Llama.cpp"
      - "local.service.description=Core Llama.cpp large language model. This is a server which performs inference."
      - "local.service.source.url=https://github.com/ggml-org/llama.cpp"
      - "portainer.agent.stack=true"
    env_file:
      - ${CORE_LLAMACPP_ENVIRONMENT_FILE}
    ports:
      - "${CORE_LLAMACPP_HOST_HTTP_PORT}:${CORE_LLAMACPP_CONTAINER_HTTP_PORT}"      
    healthcheck:
      test: ["CMD-SHELL", "curl -f http://core_llamacpp:${CORE_LLAMACPP_CONTAINER_HTTP_PORT} || exit 1"]
      interval: 30s
      timeout: 10s
      retries: 3
      start_period: 300s   
    entrypoint: /bin/sh
    command: |
      -c '
      apt-get update && apt-get install -y --no-install-recommends wget curl
      cd /models &&
      if [ ! -f "/models/Llama-3.2-3B-Instruct.Q8_0.gguf" ]; then
        wget https://huggingface.co/mradermacher/Llama-3.2-3B-Instruct-GGUF/resolve/main/Llama-3.2-3B-Instruct.Q8_0.gguf &&
        chmod 0755 "/models/Llama-3.2-3B-Instruct.Q8_0.gguf" &&
        echo "Model downloaded successfully"
      fi &&
      cd /app &&
      ./llama-server -m /models/Llama-3.2-3B-Instruct.Q8_0.gguf --host 0.0.0.0 --port ${CORE_LLAMACPP_CONTAINER_HTTP_PORT} --n-gpu-layers 48'         
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
      - host_core_llamacpp_data_models_volume:/models
    networks:
      - core_monitoring_network
      - core_ai_network
      - production_app_network
      - development_app_network

  # Core Ollama Service
  # Host Accessible at: http://localhost:${CORE_OLLAMA_HOST_HTTP_PORT}
  # Docker Accessible at: http://localhost:${CORE_OLLAMA_CONTAINER_HTTP_PORT}
  # Healthcheck status: working

  core_ollama:
    container_name: core_ollama
    image: ollama/ollama:${SERVICE_OLLAMA_VERSION}
    restart: unless-stopped
    labels:
      - "local.service.name=Core - LLM Server: Ollama"
      - "local.service.description=Core Ollama large language model inference server. This is a server which performs inference. Because more capable language models require more memory this service is being given generous memory limits."
      - "local.service.source.url=https://github.com/ollama/ollama"
      - "portainer.agent.stack=true"
    env_file:
      - ${CORE_OLLAMA_ENVIRONMENT_FILE}
    ports:
      - "${CORE_OLLAMA_HOST_HTTP_PORT}:${CORE_OLLAMA_CONTAINER_HTTP_PORT}"      
    healthcheck:
      test: ["CMD-SHELL", "curl -f http://core_ollama:${CORE_OLLAMA_CONTAINER_HTTP_PORT}/api/version || exit 1"]
      interval: 30s
      timeout: 10s
      retries: 3
      start_period: 40s      
    entrypoint: /bin/sh
    command: |
      -c '
      # Define all functions
      check_server() {
        curl -s http://core_ollama:${CORE_OLLAMA_CONTAINER_HTTP_PORT}/api/version >/dev/null 2>&1
      }
      
      wait_for_server() {
        max_attempts=30
        attempt=1
        echo "Waiting for Ollama server to be ready..."
        while [ $\$attempt -le $\$max_attempts ]; do
          if check_server; then
            echo "Ollama server is ready!"
            return 0
          fi
          echo "Attempt $\$attempt/$\$max_attempts: Server not ready, waiting..."
          sleep 10
          attempt=$\$((attempt + 1))
        done
        echo "Failed to connect to Ollama server after multiple attempts"
        return 1
      }
      
      download_model() {
        local model="$\$1"
        local max_retries=3
        local retry=1
        
        while [ $\$retry -le $\$max_retries ]; do
          echo \"Downloading model '$\$model' - Attempt $\$retry of $\$max_retries...\"
          if /bin/ollama pull "$\$model"; then
            echo \"Successfully downloaded model '$\$model'\"
            return 0
          fi
          echo \"Failed to download model '$\$model' - Attempt $\$retry\"
          retry=\$((retry + 1))
          [ $\$retry -le $\$max_retries ] && sleep 5
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
      server_pid=\$!
      
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
        download_errors=\$((download_errors + 1))
      fi
      
      echo "Downloading llama3.2:3b..."
      if ! /bin/ollama pull llama3.2:3b; then
        echo "Failed to download llama3.2:3b"
        download_errors=\$((download_errors + 1))
      fi
      
      echo "Downloading phi3.5:3.8b..."
      if ! /bin/ollama pull phi3.5:3.8b; then
        echo "Failed to download phi3.5:3.8b"
        download_errors=\$((download_errors + 1))
      fi

      # echo "Downloading qwen2.5:7b..."
      # if ! /bin/ollama pull qwen2.5:7b; then
      #  echo "Failed to download qwen2.5:7b"
      #  download_errors=\$((download_errors + 1))
      # fi        

      # echo "Downloading qwen2.5:14b..."
      # if ! /bin/ollama pull qwen2.5:14b; then
      #   echo "Failed to download qwen2.5:14b"
      #   download_errors=\$((download_errors + 1))
      # fi      

      # echo "Downloading hhao/qwen2.5-coder-tools:32b..."
      # if ! /bin/ollama pull hhao/qwen2.5-coder-tools:32b; then
      #   echo "Failed to download hhao/qwen2.5-coder-tools:32b"
      #   download_errors=\$((download_errors + 1))
      # fi      

      # Report final status
      if [ "$\$download_errors" = "0" ]; then
        echo "All models downloaded successfully!"
      else
        echo "Warning: $\$download_errors model(s) failed to download"
      fi
      
      # Keep container running
      wait $\$server_pid'
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
      - host_core_ollama_data_config_volume:/root/.ollama
      - host_core_ollama_data_models_volume:/data        
    networks:
      - core_monitoring_network      
      - core_ai_network
      - production_app_network
      - development_app_network


  # Core OpenWebUI Service
  # Host Accessible at: http://localhost:${CORE_OPENWEBUI_HOST_HTTP_PORT}
  # Docker Accessible at: http://localhost:${CORE_OPENWEBUI_HOST_HTTP_PORT}
  # Healthcheck status: working

  core_openwebui:
    container_name: core_openwebui
    image: ghcr.io/open-webui/open-webui:${SERVICE_OPENWEBUI_VERSION}
    labels:
      - "local.service.name=Core - LLM Web UI: OpenWebUI"
      - "local.service.description=Core OpenWebUI web ui for chatting with LLMs. This service must be able to communitcate with the Ollama inference server via port $CORE_OLLAMA_CONTAINER_HTTP_PORT. Certain directories for this service are made available to the host machine for the purposes of data persistence."
      - "local.service.source.url=https://github.com/open-webui/open-webui"
      - "portainer.agent.stack=true"
    restart: unless-stopped
    env_file:
      - ${CORE_OPENWEBUI_ENVIRONMENT_FILE}
    ports:
      - "${CORE_OPENWEBUI_HOST_HTTP_PORT}:${CORE_OPENWEBUI_CONTAINER_HTTP_PORT}"
    healthcheck:  
      test: ["CMD-SHELL", "curl -f http://core_openwebui:${CORE_OPENWEBUI_CONTAINER_HTTP_PORT}/auth || exit 1"]
      interval: 30s
      timeout: 10s
      retries: 3
      start_period: 40s
    depends_on:
      core_llamacpp:
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
    volumes:
      - host_core_openwebui_storage_volume:/app/backend/data         
    networks:
      - core_monitoring_network
      - core_ai_network


  # Core Kokoro TTS Service
  # Host Accessible at: http://localhost:${CORE_KOKORO_TTS_HOST_HTTP_PORT}
  # Web UI Accessible at: http://localhost:${CORE_KOKORO_TTS_HOST_HTTP_PORT}/web
  # Docker Accessible at: http://localhost:${CORE_KOKORO_TTS_HOST_HTTP_PORT}
  # Healthcheck status: working

  core_kokoro_tts:
    container_name: core_kokoro_tts
    image: ghcr.io/remsky/kokoro-fastapi-gpu:${SERVICE_KOKORO_TTS_VERSION}
    labels:
      - "local.service.name=Core - LLM TTS and Web UI: Kokoro TTS"
      - "local.service.description=Core Kokoro TTS fast api for text-to-speech. Certain directories for this service are made available to the host machine for the purposes of data persistence."
      - "local.service.source.url=https://github.com/remsky/Kokoro-FastAPI"
      - "portainer.agent.stack=true"
    restart: unless-stopped
    env_file:
      - ${CORE_KOKORO_TTS_ENVIRONMENT_FILE}
    ports:
      - "${CORE_KOKORO_TTS_HOST_HTTP_PORT}:${CORE_KOKORO_TTS_CONTAINER_HTTP_PORT}"
    healthcheck:  
      test: ["CMD", "curl", "-f", "http://core_kokoro_tts:${CORE_KOKORO_TTS_CONTAINER_HTTP_PORT}/health"]
      interval: 30s
      timeout: 10s
      retries: 3
      start_period: 300s  
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
      - host_core_kokoro_tts_data_ui_volume:/app/ui
    networks:
      - core_monitoring_network      
      - core_ai_network
      - production_app_network
      - development_app_network


  # Core GPTSOVITS TTS Service
  # Host Accessible at: http://localhost:${CORE_GPTSOVITS_TTS_HOST_HTTP_PORT}
  # Docker Accessible at: http://localhost:${CORE_GPTSOVITS_TTS_HOST_HTTP_PORT}
  # Healthcheck status: working

  core_gptsovits_tts:
    container_name: core_gptsovits_tts
    image: breakstring/gpt-sovits:${SERVICE_GPTSOVITS_TTS_VERSION}
    labels:
      - "local.service.name=Core - LLM TTS and Web UI: GPTSOVITS TTS"
      - "local.service.description=Core GPTSOVITS TTS for text-to-speech. Certain directories for this service are made available to the host machine for the purposes of data persistence."
      - "local.service.source.url=https://github.com/RVC-Boss/GPT-SoVITS"
      - "portainer.agent.stack=true"
    restart: unless-stopped
    env_file:
      - ${CORE_GPTSOVITS_TTS_ENVIRONMENT_FILE}
    ports:
      - "${CORE_GPTSOVITS_TTS_HOST_HTTP_PORT}:${CORE_GPTSOVITS_TTS_CONTAINER_HTTP_PORT}"
      - "${CORE_GPTSOVITS_WEBUI_HOST_HTTP_PORT}:${CORE_GPTSOVITS_WEBUI_CONTAINER_HTTP_PORT}"   
    healthcheck:  
      test: ["CMD", "curl", "-f", "http://core_gptsovits_tts:${CORE_GPTSOVITS_WEBUI_CONTAINER_HTTP_PORT}/"]
      interval: 30s
      timeout: 10s
      retries: 3
      start_period: 480s
    entrypoint: /bin/sh
    command: |
      -c '
      cd /workspace
      # Installing dependencies...
      apt-get update && apt-get install -y --no-install-recommends python3-pip python3-dev apt-utils curl lsof ffmpeg libsox-dev unzip git git-lfs
      apt-get clean
      rm -rf /var/lib/apt/lists/
      # git lfs install
      
      echo "Creating appuser..."
      useradd -m -u 1000 appuser || true
      
      echo "Setting owner of workspace directory to appuser..."
      chown -R appuser:appuser /workspace

      # Killing processes on ports...
      for port in ${CORE_GPTSOVITS_TTS_CONTAINER_HTTP_PORT} ${CORE_GPTSOVITS_WEBUI_CONTAINER_HTTP_PORT}; do
        pid=\$(lsof -t -i :"$\$port" 2>/dev/null)
        if [ ! -z "$\$pid" ]; then
          kill -9 "$\$pid"
        fi
      done 

      # Handle GPT-SoVITS repository
      if [ ! -d "/workspace/.github" ]; then
        echo "Downloading and extracting GPT-SoVITS from github..."
        cd /workspace
        curl -L https://github.com/RVC-Boss/GPT-SoVITS/archive/refs/heads/main.zip -o gptsovits.zip && unzip -o gptsovits.zip && cp -rf GPT-SoVITS-main/* . && cp -rf GPT-SoVITS-main/.[!.]* . 2>/dev/null || true && rm -rf GPT-SoVITS-main gptsovits.zip
      fi

      # Handle GPT-SoVITS pretrained models
      if [ ! -d "/workspace/GPT_SoVITS/pretrained_models/.git" ]; then
        echo "Updating GPT-SoVITS pretrained models from huggingface.com..."
        git clone https://huggingface.co/lj1995/GPT-SoVITS /workspace/temp
        cp -rf /workspace/temp/. /workspace/GPT_SoVITS/pretrained_models/ && rm -rf /workspace/temp
      fi

      echo "Installing requirements..."
      su appuser -c "export PATH=/home/appuser/.local/bin:\$PATH"
      su appuser -c "python3 -m pip install --upgrade pip"
      su appuser -c "pip3 cache purge"

      if [ -f "/workspace/requirements.txt" ]; then  
        su appuser -c "cd /workspace && pip3 install --no-warn-script-location --no-cache-dir -r requirements.txt"
      fi

      echo "Downloading reference voice reference_voices/bf_emma.mp3..."
      su appuser -c "mkdir -p /workspace/reference_voices"
      su appuser -c "curl -L https://github.com/SamuraiBarbi/jttw-ai-docker-stack/raw/refs/heads/main/reference_voices/reference_voice_bf_emma.mp3 -o /workspace/reference_voices/bf_emma.mp3"
      chown -R appuser:appuser /workspace
      echo "Starting api server and gradio ui..."
      
      (su -s /bin/bash appuser -c "cd /workspace && python3 api_v2.py -a 0.0.0.0 -p ${CORE_GPTSOVITS_TTS_CONTAINER_HTTP_PORT} -c GPT_SoVITS/configs/tts_infer.yaml" &)
      su -s /bin/bash appuser -c "cd /workspace && python3 GPT_SoVITS/inference_webui.py en"
      # su -s /bin/bash appuser -c "cd /workspace && python3 webui.py en"'  
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
      - host_core_gptsovits_tts_storage_volume:/workspace         
    networks:
      - core_monitoring_network
      - core_ai_network


  # Core F5 TTS Service
  # Host Accessible at: http://localhost:${CORE_F5_TTS_HOST_HTTP_PORT}
  # Docker Accessible at: http://localhost:${CORE_F5_TTS_CONTAINER_HTTP_PORT}
  # Healthcheck status: working

  core_f5_tts:
    container_name: core_f5_tts
    image: ghcr.io/swivid/f5-tts:${SERVICE_F5_TTS_VERSION}
    labels:
      - "local.service.name=Core - LLM TTS and Web UI: F5 TTS"
      - "local.service.description=Core F5 TTS for text-to-speech. Certain directories for this service are made available to the host machine for the purposes of data persistence."
      - "local.service.source.url=https://github.com/SWivid/F5-TTS"
      - "portainer.agent.stack=true"
    restart: unless-stopped
    env_file:
      - ${CORE_F5_TTS_ENVIRONMENT_FILE}
    ports:
      - "${CORE_F5_TTS_HOST_HTTP_PORT}:${CORE_F5_TTS_CONTAINER_HTTP_PORT}"
      # This would be the API server port but I've disabled it for now
      # - "8090:9998"
    healthcheck:  
      test: ["CMD", "curl", "-f", "http://core_f5_tts:${CORE_F5_TTS_CONTAINER_HTTP_PORT}/"]
      interval: 30s
      timeout: 10s
      retries: 3
      start_period: 480s
    entrypoint: /bin/sh
    command: |
      -c '      
      cd /workspace
      echo "Installing dependencies..."
      apt-get update \
      && apt-get install -y --no-install-recommends python3-pip python3-dev \
      && apt-get install -y iputils-ping wget curl man git less openssl libssl-dev unzip unar build-essential aria2 tmux vim \
      && apt-get install -y openssh-server sox libsox-fmt-all libsox-fmt-mp3 libsndfile1-dev ffmpeg \
      && apt-get install -y librdmacm1 libibumad3 librdmacm-dev libibverbs1 libibverbs-dev ibverbs-utils ibverbs-providers \
      
      rm -rf /var/lib/apt/lists/
      apt-get clean

      echo "Creating appuser..."
      useradd -m -u 1000 appuser || true
      
      echo "Setting owner of workspace directory to appuser..."
      chown -R appuser:appuser /workspace

      # Killing processes on ports...
      for port in ${CORE_F5_TTS_CONTAINER_HTTP_PORT} 9998; do
        pid=\$(lsof -t -i :"$\$port" 2>/dev/null)
        if [ ! -z "$\$pid" ]; then
          kill -9 "$\$pid"
        fi
      done 

      # Handle F5 TTS repository
      echo "Downloading and extracting F5 TTS from github..."
      cd /workspace/F5-TTS
      curl -L https://github.com/SWivid/F5-TTS/archive/refs/heads/main.zip -o f5tts.zip && unzip -o f5tts.zip && cp -rf F5-TTS-main/* . && cp -rf F5-TTS-main/.[!.]* . 2>/dev/null || true && rm -rf F5-TTS-main f5tts.zip          
      chown -R appuser:appuser /workspace

      echo "Installing requirements..."
      su appuser -c "cd /workspace/F5-TTS \
      && export PATH=/home/appuser/.local/bin:\$PATH \
      && python3 -m pip install --upgrade pip \
      && pip3 cache purge \
      && pip3 install -e . --no-cache-dir"

      cd /workspace/F5-TTS && f5-tts_infer-gradio --port ${CORE_F5_TTS_CONTAINER_HTTP_PORT} --host 0.0.0.0          
      # (cd /workspace/F5-TTS && python3 src/f5_tts/socket_server.py &)
      ping 0.0.0.0 -n 1'
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
      - host_core_f5_tts_storage_volume:/workspace 
    tty: true  
    stdin_open: true      
    networks:
      - core_monitoring_network
      - core_ai_network


# Production Services

  # Production PHP-fpm Apache2
  # Host Accessible at: http://localhost:${PRODUCTION_PHPFPM_APACHE_HOST_HTTP_PORT}
  # Docker Accessible at: http://localhost:${PRODUCTION_PHPFPM_APACHE_CONTAINER_HTTP_PORT}
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
      - ${PRODUCTION_PHPFPM_APACHE_ENVIRONMENT_FILE}
    ports:
      - "${PRODUCTION_PHPFPM_APACHE_HOST_HTTP_PORT}:${PRODUCTION_PHPFPM_APACHE_CONTAINER_HTTP_PORT}"
      - "${PRODUCTION_PHPFPM_APACHE_HOST_HTTPS_PORT}:${PRODUCTION_PHPFPM_APACHE_CONTAINER_HTTPS_PORT}"
      - "${PRODUCTION_PHPFPM_APACHE_HOST_HTTPS_PORT}:${PRODUCTION_PHPFPM_APACHE_CONTAINER_HTTP_PORT}/udp"
    healthcheck:
      test: ["CMD", "curl", "-f", "http://production_phpfpm_apache:${PRODUCTION_PHPFPM_APACHE_CONTAINER_HTTP_PORT}/"]
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
  # Host Accessible at: http://localhost:${PRODUCTION_POSTGRES_HOST_TCP_PORT}
  # Docker Accessible at: http://localhost:${PRODUCTION_POSTGRES_CONTAINER_TCP_PORT}
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
      - ${PRODUCTION_POSTGRES_ENVIRONMENT_FILE}
    ports:
      - "${PRODUCTION_POSTGRES_HOST_TCP_PORT}:${PRODUCTION_POSTGRES_CONTAINER_TCP_PORT}"
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
  # Host Accessible at: http://localhost:${PRODUCTION_MARIADB_HOST_TCP_PORT}
  # Docker Accessible at: http://localhost:${PRODUCTION_MARIADB_CONTAINER_TCP_PORT}
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
      - ${PRODUCTION_MARIADB_ENVIRONMENT_FILE}
    ports:
      - "${PRODUCTION_MARIADB_HOST_TCP_PORT}:${PRODUCTION_MARIADB_CONTAINER_TCP_PORT}"
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
  # Host Accessible at: http://localhost:${PRODUCTION_NEO4J_HOST_HTTP_PORT}
  # Docker Accessible at: http://localhost:${PRODUCTION_NEO4J_CONTAINER_HTTP_PORT}
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
      - ${PRODUCTION_NEO4J_ENVIRONMENT_FILE}
    ports:
      - "${PRODUCTION_NEO4J_HOST_HTTP_PORT}:${PRODUCTION_NEO4J_CONTAINER_HTTP_PORT}"
      - "${PRODUCTION_NEO4J_HOST_BOLT_PORT}:${PRODUCTION_NEO4J_CONTAINER_BOLT_PORT}"
    healthcheck:
      test: ["CMD", "wget", "--no-verbose", "--tries=1", "--spider", "http://production_neo4j:${PRODUCTION_NEO4J_CONTAINER_HTTP_PORT}/browser/"]
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
  # Host Accessible at: http://localhost:${DEVELOPMENT_PHPFPM_APACHE_HOST_HTTP_PORT}
  # Docker Accessible at: http://localhost:${DEVELOPMENT_PHPFPM_APACHE_CONTAINER_HTTP_PORT}
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
      - ${DEVELOPMENT_PHPFPM_APACHE_ENVIRONMENT_FILE}
    ports:
      - "${DEVELOPMENT_PHPFPM_APACHE_HOST_HTTP_PORT}:${DEVELOPMENT_PHPFPM_APACHE_CONTAINER_HTTP_PORT}"
      - "${DEVELOPMENT_PHPFPM_APACHE_HOST_HTTPS_PORT}:${DEVELOPMENT_PHPFPM_APACHE_CONTAINER_HTTPS_PORT}"
      - "${DEVELOPMENT_PHPFPM_APACHE_HOST_HTTPS_PORT}:${DEVELOPMENT_PHPFPM_APACHE_CONTAINER_HTTP_PORT}/udp"
    healthcheck:
      test: ["CMD", "curl", "-f", "http://development_phpfpm_apache:${DEVELOPMENT_PHPFPM_APACHE_CONTAINER_HTTP_PORT}/"]
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
  # Host Accessible at: http://localhost:${DEVELOPMENT_POSTGRES_HOST_TCP_PORT}
  # Docker Accessible at: http://localhost:${DEVELOPMENT_POSTGRES_CONTAINER_TCP_PORT}
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
      - ${DEVELOPMENT_POSTGRES_ENVIRONMENT_FILE}
    ports:
      - "${DEVELOPMENT_POSTGRES_HOST_TCP_PORT}:${DEVELOPMENT_POSTGRES_CONTAINER_TCP_PORT}"
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
  # Host Accessible at: http://localhost:${DEVELOPMENT_MARIADB_HOST_TCP_PORT}
  # Docker Accessible at: http://localhost:${DEVELOPMENT_MARIADB_CONTAINER_TCP_PORT}
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
      - ${DEVELOPMENT_MARIADB_ENVIRONMENT_FILE}
    ports:
      - "${DEVELOPMENT_MARIADB_HOST_TCP_PORT}:${DEVELOPMENT_MARIADB_CONTAINER_TCP_PORT}"
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
  # Host Accessible at: http://localhost:${DEVELOPMENT_NEO4J_HOST_HTTP_PORT}
  # Docker Accessible at: http://localhost:${DEVELOPMENT_NEO4J_CONTAINER_HTTP_PORT}
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
      - ${DEVELOPMENT_NEO4J_ENVIRONMENT_FILE}
    ports:
      - "${DEVELOPMENT_NEO4J_HOST_HTTP_PORT}:${DEVELOPMENT_NEO4J_CONTAINER_HTTP_PORT}"
      - "${DEVELOPMENT_NEO4J_HOST_BOLT_PORT}:${DEVELOPMENT_NEO4J_CONTAINER_BOLT_PORT}"
    healthcheck:
      test: ["CMD", "wget", "--no-verbose", "--tries=1", "--spider", "http://development_neo4j:${DEVELOPMENT_NEO4J_CONTAINER_HTTP_PORT}/browser/"]
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
  
  
  # Core AI Network is used for our AI related services/docker containers ( SearxNG, Ollama, OpenWebUI, Kokoro TTS )
 
  core_ai_network:
    driver: bridge


# Production Networks

  # Production App Network is used for our web application related services/docker containers ( PHP Apache2, Postgres, MariaDB, Neo4j, SearxNG, Ollama, Kokoro TTS )
 
  production_app_network:
    driver: bridge
  
  
  # Production DB Network is used for our database related services/docker containers ( Postgres, MariaDB, Neo4j, PGAdmin, PHPMyAdmin )
  
  production_db_network:
    driver: bridge


# Development Networks

  # Development App Network is used for our web application related services/docker containers ( PHP Apache2, Postgres, MariaDB, Neo4j, SearxNG, Ollama, Kokoro TTS )
  
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
log "To start the project, run: sudo -S docker compose up -d"
