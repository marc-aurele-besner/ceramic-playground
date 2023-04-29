#\/usr/bin/bash

BLUE='\033[0;34m'
BBLUE='\033[1;34m'
NC='\033[0m'

set -o allexport; source .env; set +o allexport

printf "${BLUE}Generate config file for Ceramic from .env
${NC}"

node ./scripts/build-config.js

printf "${BLUE}Let's run composeDB
${NC}"

pnpm ceramic daemon --config ./.generated/ceramic-config.json
