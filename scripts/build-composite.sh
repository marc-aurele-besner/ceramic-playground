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
    printf "⚠️${BYELLOW}No .env file found. Please run dev first...
${NC}"
fi

set -o allexport; source .env; set +o allexport

yourfilenames=`ls $MODELS_DIR/*.graphql`
for eachfile in $yourfilenames
do
    base_name=$(basename ${eachfile})
    file_name="${base_name%.*}"

    printf "${BLUE}Generate composite from model ${eachfile} 📦
    ${NC}"
    composedb composite:create $eachfile --ceramic-url="${CERAMIC_URL}" --did-private-key="${COMPOSEDB_ADMIN_PK}" --output=${COMPOSITE_DIR}/${file_name}.json

    printf "${BLUE}Deploy composite for model ${file_name} 🚀
    ${NC}"

    composedb composite:deploy ${COMPOSITE_DIR}/${file_name}.json --ceramic-url="${CERAMIC_URL}" --did-private-key="${COMPOSEDB_ADMIN_PK}"

    printf "${BLUE}Compile JS definitons for model ${file_name} 💾
    ${NC}"

    composedb composite:compile ${COMPOSITE_DIR}/${file_name}.json ${DEFINITION_DIR}/${file_name}.js
done

node ./scripts/format-composite.js
