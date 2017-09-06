#!/bin/bash

########################
# This is for local testing only
#######################

#MODULE=$1
#AWS_PROFILE=$2

MODULE=$1
AWS_PROFILE=$2
AWS_BUCKET_ROOT=$3
AWS_BUCKET_ENV=$4

if [ -z "$4" ]; then
    echo "Using local env"
    AWS_BUCKET_ENV="local"
fi

echo "PROFILE: $AWS_PROFILE"
echo "MODULE: $MODULE"
echo "BUCKET_ENV: $AWS_BUCKET_ENV"

## remove the image (can be removed to lighten load)
#docker rmi "jamesmtc/$MODULE" -f

## remove the container
docker rm $MODULE -f

## build the image and name it
docker build . -t "jamesmtc/$MODULE"

## run the image 
docker run -it \
    -v ~/.aws:/root/.aws \
    -e AWS_BUCKET=$AWS_BUCKET_ROOT \
    -e AWS_PROFILE=$AWS_PROFILE \
    -e AWS_BUCKET_ENV=$AWS_BUCKET_ENV \
    --name $MODULE "jamesmtc/$MODULE"

    

#docker start $MODULE

#docker attach $MODULE


