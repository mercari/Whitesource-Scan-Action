FROM ubuntu:18.04

LABEL version="1.0.0"
LABEL repository="https://github.com/mercari/Whitesource-Scan-Action"
LABEL maintainer="Azeem Shezad Ilyas <azeemilyas@hotmail.com>"

ENV DEBIAN_FRONTEND noninteractive
ENV JAVA_HOME       /usr/lib/jvm/java-8-openjdk-amd64
ENV PATH 	    	    $JAVA_HOME/bin:$PATH
ENV LANGUAGE	      en_US.UTF-8
ENV LANG    	      en_US.UTF-8
ENV LC_ALL  	      en_US.UTF-8

### Install wget, curl, git, unzip, gnupg, locales
RUN apt-get update && apt-get -y install \
      curl \
      git \
      gnupg \
      locales  \
      unzip \
      wget \
      jq \
    && locale-gen en_US.UTF-8

ARG DISTRO="bionic"

# set up node repo
ARG NODE_KEYRING=/usr/share/keyrings/nodesource.gpg
RUN curl -fsSL https://deb.nodesource.com/gpgkey/nodesource.gpg.key | gpg --dearmor | tee "$NODE_KEYRING" >/dev/null

ARG NODE_VERSION=node_16.x
RUN echo "deb [signed-by=$NODE_KEYRING] https://deb.nodesource.com/$NODE_VERSION $DISTRO main" | tee /etc/apt/sources.list.d/nodesource.list
RUN echo "deb-src [signed-by=$NODE_KEYRING] https://deb.nodesource.com/$NODE_VERSION $DISTRO main" | tee -a /etc/apt/sources.list.d/nodesource.list

# set up OpenJDK repo
RUN echo "deb http://ppa.launchpad.net/openjdk-r/ppa/ubuntu $DISTRO main" | tee /etc/apt/sources.list.d/ppa_openjdk-r.list && \
    apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys DA1A4A13543B466853BAF164EB9B1D8886F44E2A

RUN apt-get update 

### Install Java openjdk 8
RUN apt-get -y install openjdk-8-jdk

### Install Node.js (16.x) + NPM (8.x)
RUN apt-get -y install nodejs build-essential

#clean up apt 
RUN apt-get clean && \
	rm -rf /var/lib/apt/lists/* && \
	rm -rf /tmp/*

# Install GO:
ARG GOLANG_VERSION=1.17.7

ARG GO_URL="https://dl.google.com/go/go${GOLANG_VERSION}.linux-amd64.tar.gz"
# https://github.com/golang/go/issues/14739#issuecomment-324767697
RUN	curl -fsSL -o go.tgz.asc "$GO_URL.asc"; \
    curl -fsSL -o go.tgz "$GO_URL"; \
    GNUPGHOME="$(mktemp -d)"; export GNUPGHOME; \
# https://www.google.com/linuxrepositories/
	  gpg --batch --keyserver keyserver.ubuntu.com --recv-keys 'EB4C 1BFD 4F04 2F6D DDCC  EC91 7721 F63B D38B 4796'; \
# let's also fetch the specific subkey of that key explicitly that we expect "go.tgz.asc" to be signed by, just to make sure we definitely have it
	  gpg --batch --keyserver keyserver.ubuntu.com --recv-keys '2F52 8D36 D67B 69ED F998  D857 78BD 6547 3CB3 BD13'; \
    gpg --batch --verify go.tgz.asc go.tgz; \
	  gpgconf --kill all; \
	  rm -rf "$GNUPGHOME" go.tgz.asc; \
    tar -C /usr/local -xzf go.tgz; \
	  rm go.tgz

# Set GO environment variables
ENV PATH /usr/local/go/bin:$PATH
RUN go version

ENV GOPATH /go
ENV PATH $GOPATH/bin:$PATH
RUN mkdir -p "$GOPATH/src" "$GOPATH/bin" && chmod -R 777 "$GOPATH"

COPY entrypoint.sh /entrypoint.sh
COPY list-project-alerts.sh /list-project-alerts.sh

ENTRYPOINT ["/entrypoint.sh"]
