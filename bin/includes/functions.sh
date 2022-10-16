#!/bin/bash
set -e

message() {
  echo ""
  echo -e "$1"
  seq ${#1} | awk '{printf "-"}'
  echo ""
}

runCommand() (
  message "$1"
  eval "$1"
)

setEnvironment() {
  if [[ $1 ]]; then
    file="$1/.env"
    if [ ! -f "$file" ]; then
      runCommand "cp $1/.env.temp $file"
    fi

    # shellcheck disable=SC1090
    source "$file"
  fi
}

setEnvironment "$1"

nodeContainer="docker exec -it ${NAMESPACE}_node sh -lc"
nodeContainerRoot="docker exec -it -u root ${NAMESPACE}_node sh -lc"

getLogo() {
  echo "                             _____      _            _             "
  echo "                            / __  \    | |          | |            "
  echo " _ __ ___   __ _  __ _  ___ \`' / /'  __| | ___   ___| | _____ _ __ "
  echo "| '_ \` _ \ / _\` |/ _\` |/ _ \  / /   / _\` |/ _ \ / __| |/ / _ \ '__|"
  echo "| | | | | | (_| | (_| |  __/./ /___| (_| | (_) | (__|   <  __/ |   "
  echo "|_| |_| |_|\__,_|\__, |\___|\_____(_)__,_|\___/ \___|_|\_\___|_|   "
  echo "                  __/ |                                            "
  echo "                 |___/                                             "
}

dockerRefresh() {
  if [[ $(uname -s) == "Darwin" ]]; then
    runCommand "docker-sync stop &&
                docker-sync start &&
                docker-compose -f docker-compose.osx.yml down &&
                docker-compose -f docker-compose.osx.yml up -d"
  else
    runCommand "docker-compose down && docker-compose up -d"
  fi
}

pwaClone() {
  if [ ! -d "$WORKDIR_NODE" ]; then
    commands="git clone https://github.com/magento/pwa-studio.git $WORKDIR_NODE && cd $WORKDIR_NODE"
    runCommand "$commands"
  fi
}

pwaConfig() {
  commands="npm config set prefix '$WORKDIR_SERVER_NODE/.npm-global'"
  runCommand "$nodeContainer '$commands'"

  commands="
  buildpack create-project /home/node \
  --template \"@magento/venia-concept\" \
  --name \"pwa\" \
  --author \"mage2.docker\" \
  --backend-url \"https://master-7rqtwti-mfwmkrjfqvbjk.us-4.magentosite.cloud/\" \
  --braintree-token \"sandbox_8yrzsvtm_s2bg8fs563crhqzk\" \
  --npm-client \"npm\" \
  --no-install"

  runCommand "$nodeContainer '$commands'"
}

npmInstall() {
  commands="npm --legacy-peer-deps install"
  runCommand "$nodeContainer '$commands'"
}

npmCert() {
  commands="export 'NODE_OPTIONS=--openssl-legacy-provider' && npm run buildpack -- create-custom-origin ./"
  runCommand "$nodeContainerRoot '$commands'"
}

npmRun() {
  commands="npm run $1"
  runCommand "$nodeContainer '$commands'"
}

pwaRun() {
  # if [ ! -f "$WORKDIR_NODE/package.json" ]; then
  npmInstall
  pwaConfig
  npmCert
  # fi

  npmRun "watch"
}
