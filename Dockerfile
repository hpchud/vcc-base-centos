FROM centos:7

# install packages required
RUN yum -y install make gcc gcc-c++ git nano openssh-server openssh-clients

# install n
WORKDIR /
RUN git clone https://github.com/tj/n.git \
	&& cd n \
	&& make \
	&& make install \
	&& cd .. \
	&& rm -r n

# use n to install node
RUN n 6.9.5

# install vccjs
WORKDIR /
RUN git clone https://github.com/hpchud/vccjs.git \
	&& cd vccjs \
	&& git checkout -q 4170b69f030e3b6d96c0a782041d242a0d0a102b
WORKDIR /vccjs
RUN npm install

# install configuration files
RUN cp /vccjs/cluster.yml /etc/cluster.yml
RUN mkdir -p /etc/vcc

# cluster hook scripts
RUN mkdir -p /etc/vcc/cluster-hooks.d

# service hook scripts
RUN mkdir /etc/vcc/service-hooks.d

# remove unneeded systemd units
RUN (cd /lib/systemd/system/sysinit.target.wants/; for i in *; do [ $i == systemd-tmpfiles-setup.service ] || rm -f $i; done); \
rm -f /lib/systemd/system/multi-user.target.wants/*;\
rm -f /etc/systemd/system/*.wants/*;\
rm -f /lib/systemd/system/local-fs.target.wants/*; \
rm -f /lib/systemd/system/sockets.target.wants/*udev*; \
rm -f /lib/systemd/system/sockets.target.wants/*initctl*; \
rm -f /lib/systemd/system/basic.target.wants/*;\
rm -f /lib/systemd/system/anaconda.target.wants/*;

# install systemd services
RUN cp -r /vccjs/systemd/*.service /etc/systemd/system/
RUN cp -r /vccjs/systemd/*.target /etc/systemd/system/
RUN cd /etc/systemd/system && systemctl enable vcc*

# install a service to trigger the network targets
ADD container-network.service /etc/systemd/system/container-network.service
RUN systemctl enable container-network.service
RUN systemctl enable sshd

# volumes for systemd
VOLUME ["/sys/fs/cgroup", "/tmp", "/run", "/run/lock"]

# launch script
WORKDIR /
ENTRYPOINT ["/vccjs/launch.sh"]
