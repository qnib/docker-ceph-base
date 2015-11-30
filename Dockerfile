FROM qnib/d-terminal

ENV CEPH_VERSION=hammer \
    DEBIAN_VERSION=jessie


# Install prerequisites
RUN apt-get update &&  apt-get install -y wget unzip

# Install Ceph
RUN wget -q -O- 'https://download.ceph.com/keys/release.asc' | apt-key add - && \
   echo deb http://ceph.com/debian-${CEPH_VERSION}/ ${DEBIAN_VERSION} main | tee /etc/apt/sources.list.d/ceph-${CEPH_VERSION}.list && \
   apt-get update && apt-get install -y --force-yes ceph radosgw && \
   apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
