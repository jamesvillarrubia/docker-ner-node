
DOCKER_USER="jamesmtc"
DOCKER_PASS="1Rekcod@kbw17"
DOCKER_IMAGE_NAME="ner-node"
docker build . -t "jamesmtc/$DOCKER_IMAGE_NAME"
docker login --username=$DOCKER_USER --password=$DOCKER_PASS
docker tag $DOCKER_IMAGE_NAME $DOCKER_USER/$DOCKER_IMAGE_NAME
docker push $DOCKER_USER/$DOCKER_IMAGE_NAME