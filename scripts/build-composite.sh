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

DEFAULT_COMPOSITE_PATH='my-composite.json'
DEFAULT_MODEL_ID='kjzl6hvfrbw6c5sffjlmczg8nmbk8kwu9lmgiqfd9bxi7pxp14u674cuxp09szz'

if [ -z ${COMPOSITE_PATH+x} ]; then
    printf "${BYELLOW}.env No COMPOSITE_PATH set in .env. Using default: ${DEFAULT_COMPOSITE_PATH}
${NC}"
    echo "COMPOSITE_PATH=\"${DEFAULT_COMPOSITE_PATH}\"" >> .env
    COMPOSITE_PATH=${DEFAULT_COMPOSITE_PATH}
    printf "${BGREEN}.env COMPOSITE_PATH set to ${DEFAULT_COMPOSITE_PATH} in .env file 📝
${NC}"
fi

if [ -z ${MODEL_ID+x} ]; then
    printf "${BYELLOW}.env No MODEL_ID set in .env. Using default: ${DEFAULT_MODEL_ID}
${NC}"
    echo "MODEL_ID=\"${DEFAULT_MODEL_ID}\"" >> .env
    MODEL_ID=${DEFAULT_MODEL_ID}
    printf "${BGREEN}.env MODEL_ID set to ${DEFAULT_MODEL_ID} in .env file 📝
${NC}"
fi

printf "${BLUE}Generate composite from model ${MODEL_ID} 📦
${NC}"

pnpm composedb composite:from-model ${MODEL_ID} --ceramic-url="${CERAMIC_URL}" --did-private-key="${COMPOSEDB_ADMIN_PK}" --output=${COMPOSITE_DIR}/${COMPOSITE_PATH}

node ./scripts/format-composite.js
