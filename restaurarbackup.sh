#!/bin/bash
# Shell script to restore a backup
#
# Desarrollado para platzi by  Jhon Edison Castro Sánchez @edisoncast

set -e

readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
readonly SCRIPT_NAME="$(basename "$0")"

run
restore_backup

function assert_is_installed {
  local readonly name="$1"

  if [[ ! $(command -v ${name}) ]]; then
    log_error "The binary '$name' is required by this script but is not installed or in the system's PATH."
    exit 1
  fi
}

function log_error {
  local readonly message="$1"
  log "ERROR" "$message"
}

function log {
  local readonly level="$1"
  local readonly message="$2"
  local readonly timestamp=$(date +"%Y-%m-%d %H:%M:%S")
  >&2 echo -e "${timestamp} [${level}] [$SCRIPT_NAME] ${message}"
}

function run {
  assert_is_installed "mysql"
  assert_is_installed "mysqldump"
  assert_is_installed "gzip"
  assert_is_installed "aws"
}

function restore_backup {
    local BAK="$(echo $HOME/restore)"
    local MYSQL="$(which mysql)"
    local GZIP="$(which gzip)"
    local NOW=$(date +"%d-%m-%Y")
    local BUCKET="xxxxx"
    local DATABASE="xxxxxxx"
    USER="xxxxxx"
    PASS="xxxxxx"
    HOST="xxxxxxxx"
    DATABASE="xxxxx"

    [ ! -d "$BAK" ] && mkdir -p "$BAK"

    FILE=$BAK/$DATABASE.$NOW-$(date +"%T").gz

    local SECONDS=0

    aws configure set s3.signature_version s3v4
    aws s3 sync "s3://$BUCKET" $BAK --exact-timestamps

    cd $BAK

    local FILE="$(find . -iname "*.gz" -type f -print0 | xargs --no-run-if-empty -0 stat -c "%y %n" | sort -r | head -n 1 |awk '{print $4}')"

    gunzip < $FILE | $MYSQL -u $USER -h $HOST -p$PASS $DATABASE

    duration=$SECONDS
    echo "$(($duration / 60)) minutes and $(($duration % 60)) seconds elapsed."
}
