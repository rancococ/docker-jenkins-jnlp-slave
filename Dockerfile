# from registry.cn-hangzhou.aliyuncs.com/rancococ/oraclejdk:1.8.0_192-3-centos
FROM registry.cn-hangzhou.aliyuncs.com/rancococ/oraclejdk:1.8.0_192-3-centos

# maintainer
MAINTAINER "rancococ" <rancococ@qq.com>

# set label
LABEL Description="This is a base image, which allows connecting Jenkins agents via JNLP protocols" Vendor="Jenkins project" Version="${VERSION}"

# set arg info
ARG VERSION=3.29
ARG user=jenkins
ARG group=jenkins
ARG uid=1000
ARG gid=1000
ARG AGENT_WORKDIR=/home/${user}/agent

ENV HOME /home/${user}
ENV AGENT_WORKDIR=${AGENT_WORKDIR}

# copy script
COPY jenkins-slave /usr/local/bin/jenkins-slave

# install jenkins/slave.jar
RUN groupadd -g ${gid} ${group} && \
    useradd -d $HOME -u ${uid} -g ${gid} ${user} && \
    curl --create-dirs -fsSLo /usr/share/jenkins/slave.jar https://repo.jenkins-ci.org/public/org/jenkins-ci/main/remoting/${VERSION}/remoting-${VERSION}.jar && \
    chmod 755 /usr/share/jenkins && \
    chmod 644 /usr/share/jenkins/slave.jar && \
    chmod 755 /usr/local/bin/jenkins-slave && \
    chown ${uid}:${gid} /usr/local/bin/jenkins-slave

# set user
USER ${user}

RUN mkdir /home/${user}/.jenkins && mkdir -p ${AGENT_WORKDIR}

# set volume info
VOLUME /home/${user}/.jenkins
VOLUME ${AGENT_WORKDIR}

# set work home
WORKDIR /home/${user}

# entry point
ENTRYPOINT ["jenkins-slave"]

