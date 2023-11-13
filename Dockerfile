FROM bellsoft/liberica-openjdk-debian:17
LABEL maintainer="mikheevevgeny@gmail.com" version="1.0" description="Docker image based on bellsoft/liberica-openjdk-debian:17 withv maven, npm, nodejs and sshpass"

RUN curl -sL https://deb.nodesource.com/setup_20.x | bash -
RUN apt-get update
RUN apt-get upgrade -y
RUN apt-get install -y sshpass nodejs build-essential
RUN apt-get clean all
RUN rm -rf /var/lib/apt/lists/*

ARG MAVEN_VERSION=3.9.5
ARG USER_HOME_DIR="/root"
ARG SHA=4810523ba025104106567d8a15a8aa19db35068c8c8be19e30b219a1d7e83bcab96124bf86dc424b1cd3c5edba25d69ec0b31751c136f88975d15406cab3842b
ARG BASE_URL=https://apache.osuosl.org/maven/maven-3/${MAVEN_VERSION}/binaries

RUN mkdir -p /usr/share/maven /usr/share/maven/ref \
  && curl -fsSL -o /tmp/apache-maven.tar.gz ${BASE_URL}/apache-maven-${MAVEN_VERSION}-bin.tar.gz \
  && echo "${SHA}  /tmp/apache-maven.tar.gz" | sha512sum -c - \
  && tar -xzf /tmp/apache-maven.tar.gz -C /usr/share/maven --strip-components=1 \
  && rm -f /tmp/apache-maven.tar.gz \
  && ln -s /usr/share/maven/bin/mvn /usr/bin/mvn

ENV MAVEN_HOME /usr/share/maven
ENV MAVEN_CONFIG "$USER_HOME_DIR/.m2"

COPY mvn-entrypoint.sh /usr/local/bin/mvn-entrypoint.sh
COPY settings-docker.xml /usr/share/maven/ref/

ENTRYPOINT ["/usr/local/bin/mvn-entrypoint.sh"]
CMD ["mvn"]
