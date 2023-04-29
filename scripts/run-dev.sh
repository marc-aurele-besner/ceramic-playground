#\/usr/bin/bash

BLUE='\033[0;34m'
BBLUE='\033[1;34m'
BGREEN='\033[1;32m'
BYELLOW='\033[1;33m'
NC='\033[0m'

if test -f .env; then
    printf "${BLUE}.env file found. Using it...
    ${NC}"
else
    printf "${BYELLOW}No .env file found. Generating one...
${NC}"
    printf "${BBLUE}Generate a admin private key (seed) .env 🏗️
${NC}"
    pk=$(composedb did:generate-private-key)
    echo "COMPOSEDB_ADMIN_PK=\"$pk\"" > .env
    printf "${BGREEN}Admin private key (seed) generated: $pk
${NC}"
    did=$(composedb did:from-private-key $pk)
    echo "COMPOSEDB_ADMIN_DID=\"$did\"" >> .env
    printf "${BGREEN}Admin DID generated: $did
${NC}"
    printf "${BBLUE}Everything saved to .env file 💪
${NC}"
fi


set -o allexport; source .env; set +o allexport

printf "${BLUE}Generate config file for Ceramic from .env 📦
${NC}"

node ./scripts/build-config.js

printf "${BLUE}Let's run composeDB 🧪
${NC}"

pnpm ceramic daemon --config ./.generated/ceramic-config.json
