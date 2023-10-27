FROM ubuntu:22.04

#https://stackoverflow.com/questions/66205286/enable-systemctl-in-docker-container

RUN echo 'root:root' | chpasswd
RUN printf '#!/bin/sh\nexit 0' > /usr/sbin/policy-rc.d

RUN apt update
RUN apt install -y \
    systemd \
    systemd-sysv \
    dbus dbus-user-session
RUN apt install -y wget gnupg2
RUN apt install -y --no-install-recommends \
    gettext-base \
    openssh-server \
    ca-certificates
    # && rm -rf /var/lib/apt/lists/*

# for ansible
RUN apt install -y curl python3-apt
RUN curl -sS https://bootstrap.pypa.io/get-pip.py | python3
# Utils for debugging inside container
RUN apt install -y vim less bash-completion iproute2 iputils-ping net-tools

# Instal kernel-devel for beegfs (need old repos or should switch to Ubuntu18.04)
# Kernel must match the one on the host
# Worth it for using same ubuntu on the prod environment?
RUN apt install -y add-apt-key
RUN add-apt-key --keyserver keyserver.ubuntu.com 3B4FE6ACC0B21F32

RUN echo "deb http://fr.archive.ubuntu.com/ubuntu/ bionic universe" >> /etc/apt/sources.list
RUN echo "deb http://fr.archive.ubuntu.com/ubuntu/ bionic-updates main restricted" >> /etc/apt/sources.list
RUN echo "deb http://fr.archive.ubuntu.com/ubuntu/ bionic universe" >> /etc/apt/sources.list
RUN echo "deb http://fr.archive.ubuntu.com/ubuntu/ bionic multiverse" >> /etc/apt/sources.list
RUN echo "deb http://fr.archive.ubuntu.com/ubuntu/ bionic-backports main restricted universe multiverse" >> /etc/apt/sources.list
RUN echo "deb http://security.ubuntu.com/ubuntu bionic-security main restricted" >> /etc/apt/sources.list

RUN apt update
RUN apt install -y \
    linux-headers-generic \
    linux-headers-4.15.0-213 \
    linux-headers-4.15.0-213-generic

RUN printf "systemctl start systemd-logind" >> /etc/profile
RUN sed -i 's/#\?PermitRootLogin .*/PermitRootLogin yes/' /etc/ssh/sshd_config

VOLUME [ "/sys/fs/cgroup" ]
VOLUME [ "/beegfs/meta" ]
VOLUME [ "/beegfs/storage" ]

RUN systemctl enable ssh

# Make every container able to SSH into another one
RUN mkdir -p /root/.ssh
RUN ssh-keygen -q -t rsa -f /root/.ssh/id_rsa -N ''
RUN cat /root/.ssh/id_rsa.pub >> /root/.ssh/authorized_keys

RUN apt install -y attr

EXPOSE 22

CMD ["/sbin/init", "2>&1"]
