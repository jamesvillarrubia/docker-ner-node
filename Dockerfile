
###### START WITH NODE 6.1 (compatible with new AWS lambda... because yeah why not)
FROM mhart/alpine-node:8
MAINTAINER James Villarrubia "james.villarrubia@gmail.com"

ENV JAVA_HOME /opt/openjdk-13
ENV PATH $JAVA_HOME/bin:$PATH

# https://jdk.java.net/
ENV JAVA_VERSION 13-ea+16
ENV JAVA_URL https://download.java.net/java/early_access/alpine/16/binaries/openjdk-13-ea+16_linux-x64-musl_bin.tar.gz
ENV JAVA_SHA256 1e3bcc2efccf17b1c86053dece5c9f5543d9c0ec1809a2586e89d3fe0e20e37d
# "For Alpine Linux, builds are produced on a reduced schedule and may not be in sync with the other platforms."

RUN apk update \
	&& apk add ca-certificates wget \
	&& update-ca-certificates

RUN set -eux; \
	\
	wget -O /openjdk.tgz "$JAVA_URL"; \
	echo "$JAVA_SHA256 */openjdk.tgz" | sha256sum -c -; \
	mkdir -p "$JAVA_HOME"; \
	tar --extract --file /openjdk.tgz --directory "$JAVA_HOME" --strip-components 1; \
	rm /openjdk.tgz; \
	\
# https://github.com/docker-library/openjdk/issues/212#issuecomment-420979840
# https://openjdk.java.net/jeps/341
	java -Xshare:dump; \
	\
# basic smoke test
	java --version; \
	javac --version


RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app

# Download and unzip the stanford library
# RUN wget -O ner.zip http://nlp.stanford.edu/software/stanford-ner-2015-04-20.zip
RUN wget -O ner.zip https://nlp.stanford.edu/software/stanford-ner-2018-10-16.zip
RUN unzip ner.zip


# ENTRYPOINT [ "/bin/sh" ] 

# Install app dependencies
COPY package.json /usr/src/app/
RUN npm install

# Bundle app source
COPY ./index.js /usr/src/app

EXPOSE 8080

CMD [ "npm", "start" ]
