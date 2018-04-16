#!/bin/bash
    # $npm_package_config_module_name $npm_package_config_aws_profile $npm_package_config_aws_bucket_root",

MODULE=$1           # $npm_package_config_module_name
AWS_PROFILE=$2      # $npm_package_config_aws_profile
AWS_BUCKET_ROOT=$3  # $npm_package_config_aws_bucket_root
FULL_ENV=$4         # read in from cli
ABBREV_ENV=$4
MEMORY=$5

# if the environment is empty default to local
if [ -z "$4" ]; then
    echo "Using local env"
    FULL_ENV="local"
    ABBREV_ENV="local"
fi

# if the memory setting is empty default to 128
if [ -z "$4" ]; then
    echo "Setting memory to 128"
    MEMORY=128
fi

if [ -f ./claudia.json ]; then
   echo 'Updating lambda via docker container.'
else
   echo 'Creating lambda via docker container.'
   npm run build
#  npm run dockerize-create -- --profile $AWS_PROFILE
   claudia create --deploy-proxy-api --region us-east-1 --handler \"dist/lambda.handler\" --timeout 90 --use-local-dependencies --version $FULL_ENV --profile $AWS_PROFILE --memory $MEMORY
fi


# Set the abbreviated versions of things
if [[ "$ABBREV_ENV" == "production" ]]; then
    ABBREV_ENV='prod'
fi

if [[ "$FULL_ENV" == "production" ||  "$FULL_ENV" == "staging" ]]; then
    AWS_NODE_ENV='production'
else
    AWS_NODE_ENV='development'
fi


echo "AWS_PROFILE: $AWS_PROFILE"
echo "MODULE: $MODULE"  # api-mt-clevere-st
echo "FULL_ENV: $FULL_ENV" # qa, develop, production, staging
echo "AWS_BUCKET_ROOT: $AWS_BUCKET_ROOT" # api.mt.clevere.st
echo "ABBREV_ENV: $ABBREV_ENV" #qa, develop, prod, staging

## remove the image (can be removed to lighten load)
# docker rmi "$MODULE/$FULL_ENV" -f

## remove the container
docker rm "$MODULE-$FULL_ENV" -f

## build the image and name it
docker build \
    --build-arg AWS_BUCKET_ROOT=$AWS_BUCKET_ROOT \
    --build-arg AWS_PROFILE=$AWS_PROFILE \
    --build-arg FULL_ENV=$FULL_ENV \
    --build-arg MODULE=$MODULE \
    --build-arg ABBREV_ENV=$ABBREV_ENV \
    --build-arg AWS_NODE_ENV=$AWS_NODE_ENV \
    . -t "$MODULE/$FULL_ENV" 


## run the image 
docker run -it \
    -v ~/.aws:/root/.aws \
    -e AWS_BUCKET_ROOT=$AWS_BUCKET_ROOT \
    -e AWS_PROFILE=$AWS_PROFILE \
    -e FULL_ENV=$FULL_ENV \
    -e MODULE=$MODULE \
    -e ABBREV_ENV=$ABBREV_ENV \
    -e AWS_NODE_ENV=$AWS_NODE_ENV \
    --name "$MODULE-$FULL_ENV" "$MODULE/$FULL_ENV"

    
# docker run -it -v ~/.aws:/root/.aws -e AWS_BUCKET_ROOT="api.mt.clevere.st" -e AWS_PROFILE=mtc-api-gitlab -e FULL_ENV=develop -e MODULE=api-mt-clevere-st -e ABBREV_ENV=develop -e AWS_NODE_ENV=development --name "api-mt-clevere-st-develop" "api-mt-clevere-st/develop"

#docker start $MODULE

#docker attach $MODULE

