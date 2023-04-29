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
    printf "⚠️${BYELLOW}No .env file found. Please run pnpm dev first...
${NC}"
fi


set -o allexport; source .env; set +o allexport

MODEL_ID='kjzl6hvfrbw6c5sffjlmczg8nmbk8kwu9lmgiqfd9bxi7pxp14u674cuxp09szz'
COMPOSITE_DIR='./.generated/composite'

printf "${BLUE}Generate composite from model ${MODEL_ID} 📦
${NC}"

pnpm composedb composite:from-model ${MODEL_ID} --ceramic-url="http:/0.0.0.0:7007" --did-private-key="${COMPOSEDB_ADMIN_PK}" --output=${COMPOSITE_DIR}/my-composite.json

node ./scripts/format-composite.js
