#!/bin/bash

generate_password(){
    echo $(< /dev/urandom tr -dc a-zA-Z0-9 | head -c16 | base64 -i)
}


# Load up .env
set -o allexport
[[ -f .env ]] && source .env
set +o allexport

# Checks
if [ -z "$1" ] || [ "$1" = "-d" ] ; then
    echo -e "Usage:"
    echo -e "  $0 user [-d]"
    echo -e ""
    echo -e "Options:"
    echo -e "  -d\tUse docker-compose (Requires CID in .env or as env variable)"
    echo -e ""
    echo -e "Env vars:"
    echo -e "  MONGO_INITDB_ROOT_USERNAME\troot username"
    echo -e "  MONGO_INITDB_ROOT_PASSWORD\troot password"
    echo -e ""
    echo -e "env vars is also taken from $PWD/.env"
    exit 1
fi

USE_DOCKER=false

if [ "$2" = "-d" ] ; then
    USE_DOCKER=true
fi

if [ "$USE_DOCKER" = true ] && [ -z "$CID" ] ; then
    echo -e "Container id is needed!"
    echo -e "Put it in .env or prepend to script like CID=mongo $0"
    exit 1
fi

# Generate creds
USER="$1"
PASSWD=$(generate_password)

echo -e "Credentials:"
echo -e "$USER:$PASSWD"

EVAL_CMD="db.createUser({ user: '$USER', pwd: '$PASSWD', roles: [ { role: 'readWrite', db: '$USER'}]});"

# echo $EVAL_CMD

cmd="mongo"

if [ "$USE_DOCKER" = true ] ; then
    cmd="docker-compose exec $CID $cmd"
fi

if [ ! -z "$MONGO_INITDB_ROOT_USERNAME" ] ; then
    cmd="$cmd -u $MONGO_INITDB_ROOT_USERNAME"
fi

if [ ! -z "$MONGO_INITDB_ROOT_PASSWORD" ] ; then
    cmd="$cmd -p $MONGO_INITDB_ROOT_PASSWORD"
fi

cmd="$cmd --eval \"$EVAL_CMD\""

echo $cmd

eval $cmd