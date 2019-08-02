# from registry.cn-hangzhou.aliyuncs.com/rancococ/oraclejdk:1.8.0_192.6-centos
FROM registry.cn-hangzhou.aliyuncs.com/rancococ/oraclejdk:1.8.0_192.6-centos

# maintainer
MAINTAINER "rancococ" <rancococ@qq.com>

# set label
LABEL Description="This is a base image, which allows connecting Jenkins agents via JNLP protocols" Vendor="Jenkins project" Version="${VERSION}"

# set arg info
ARG VERSION=3.29
ARG USER=jenkins
ARG GROUP=jenkins
ARG UID=1000
ARG GID=1000
ARG AGENT_WORKDIR=/home/${USER}/agent

ENV HOME /home/${USER}
ENV AGENT_WORKDIR=${AGENT_WORKDIR}

# copy script
COPY jenkins-slave /usr/local/bin/jenkins-slave

# install jenkins/slave.jar
RUN groupadd -g ${GID} ${GROUP} && \
    useradd -d $HOME -u ${UID} -g ${GID} ${USER} && \
    curl --create-dirs -fsSLo /usr/share/jenkins/slave.jar https://repo.jenkins-ci.org/public/org/jenkins-ci/main/remoting/${VERSION}/remoting-${VERSION}.jar && \
    chmod 755 /usr/share/jenkins && \
    chmod 644 /usr/share/jenkins/slave.jar && \
    chmod 755 /usr/local/bin/jenkins-slave && \
    chown ${UID}:${GID} /usr/local/bin/jenkins-slave

# set user
USER ${USER}

RUN mkdir -p /home/${USER}/.jenkins && \
    touch /home/${USER}/.gitconfig && \
    mkdir -p /home/${USER}/.subversion && \
    mkdir -p ${AGENT_WORKDIR}

# set volume info
VOLUME /home/${USER}/.jenkins
VOLUME /home/${USER}/.gitconfig
VOLUME /home/${USER}/.subversion
VOLUME ${AGENT_WORKDIR}

# set work home
WORKDIR /home/${USER}

# entry point
ENTRYPOINT ["jenkins-slave"]

