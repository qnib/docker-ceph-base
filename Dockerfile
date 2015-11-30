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
   apt-get update && apt-get install -y --force-yes ceph radosgw && \
   apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
ADD etc/consul-templates/templates/ceph.conf.ctmpl /etc/consul-templates/templates/

# Install etcdctl
RUN wget -q -O- "https://github.com/coreos/etcd/releases/download/${ETCDCTL_VERSION}/etcd-${ETCDCTL_VERSION}-${ETCDCTL_ARCH}.tar.gz" |tar xfz - -C/tmp/ etcd-${ETCDCTL_VERSION}-${ETCDCTL_ARCH}/etcdctl
RUN mv /tmp/etcd-${ETCDCTL_VERSION}-${ETCDCTL_ARCH}/etcdctl /usr/local/bin/etcdctl

#install kviator
ADD https://github.com/AcalephStorage/kviator/releases/download/v${KVIATOR_VERSION}/kviator-${KVIATOR_VERSION}-linux-amd64.zip /tmp/kviator.zip
RUN cd /usr/local/bin && unzip /tmp/kviator.zip && chmod +x /usr/local/bin/kviator && rm /tmp/kviator.zip

# Install confd
ADD https://github.com/kelseyhightower/confd/releases/download/v${CONFD_VERSION}/confd-${CONFD_VERSION}-linux-amd64 /usr/local/bin/confd
RUN chmod +x /usr/local/bin/confd && mkdir -p /etc/confd/conf.d && mkdir -p /etc/confd/templates
