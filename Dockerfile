FROM qnib/d-terminal

ENV CEPH_VERSION=hammer \
    DEBIAN_VERSION=jessie \
    ETCDCTL_VERSION=v2.2.0 \
    ETCDCTL_ARCH=linux-amd64

ENV KVIATOR_VERSION 0.0.5
ENV CONFD_VERSION 0.10.0


# Install prerequisites
RUN apt-get update &&  apt-get install -y wget unzip jq

# Install Ceph
RUN wget -q -O- 'https://download.ceph.com/keys/release.asc' | apt-key add - && \
   echo deb http://ceph.com/debian-${CEPH_VERSION}/ ${DEBIAN_VERSION} main | tee /etc/apt/sources.list.d/ceph-${CEPH_VERSION}.list && \
   apt-get update 
