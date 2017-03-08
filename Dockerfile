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

# install init8js
WORKDIR /
RUN git clone https://github.com/joshiggins/init8js.git \
	&& cd init8js \
	&& git checkout -q dcb5e6cf0c5fd6e819dd029321f44a0be1e5e21b
WORKDIR /init8js
RUN npm install
RUN cp -r node_modules /lib/
RUN cp log.js /lib/node_modules/

# install vccjs
WORKDIR /
RUN git clone https://github.com/hpchud/vccjs.git \
	&& cd vccjs \
	&& git checkout -q 2ba5123a134aed2a24fa00ae5f6b981283b044c5
WORKDIR /vccjs
RUN npm install

# install configuration files
RUN cp /vccjs/init.yml /etc/init.yml
RUN cp /vccjs/services.yml /etc/services.yml
RUN mkdir -p /etc/vcc

# cluster hook scripts
RUN mkdir -p /etc/vcc/cluster-hooks.d

# service hook scripts
RUN mkdir /etc/vcc/service-hooks.d

WORKDIR /
ENTRYPOINT ["/vccjs/launch.sh"]
