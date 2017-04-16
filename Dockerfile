
###### START WITH NODE 6.1 (compatible with new AWS lambda... because yeah why not)
FROM mhart/alpine-node:6.10.2
MAINTAINER James Villarrubia "james.villarrubia@gmail.com"

###### THE STANDARD STUFF INSTALL
#RUN apt-get update
#RUN apt-get -y install \
	# build-essential \
#	wget \
	#unzip \
#	git 




# Default to UTF-8 file.encoding
ENV LANG C.UTF-8

# add a simple script that can auto-detect the appropriate JAVA_HOME value
# based on whether the JDK or only the JRE is installed
RUN { \
		echo '#!/bin/sh'; \
		echo 'set -e'; \
		echo; \
		echo 'dirname "$(dirname "$(readlink -f "$(which javac || which java)")")"'; \
	} > /usr/local/bin/docker-java-home \
	&& chmod +x /usr/local/bin/docker-java-home
ENV JAVA_HOME /usr/lib/jvm/java-1.8-openjdk
ENV PATH $PATH:/usr/lib/jvm/java-1.8-openjdk/jre/bin:/usr/lib/jvm/java-1.8-openjdk/bin

ENV JAVA_VERSION 8u111
ENV JAVA_ALPINE_VERSION 8.111.14-r0

RUN set -x \
	&& apk add --no-cache \
		openjdk8="$JAVA_ALPINE_VERSION" \
	&& [ "$JAVA_HOME" = "$(docker-java-home)" ]



RUN apk update \
	&& apk add ca-certificates wget \
	&& update-ca-certificates

###### NOW THE HEART OF THE MATTER

# Create app directory
RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app

# Download and unzip the stanford library
RUN wget -O ner.zip http://nlp.stanford.edu/software/stanford-ner-2015-04-20.zip
RUN unzip ner.zip

# Install app dependencies
COPY package.json /usr/src/app/
RUN npm install

# Bundle app source
COPY ./index.js /usr/src/app

EXPOSE 8080

CMD [ "npm", "start" ]


