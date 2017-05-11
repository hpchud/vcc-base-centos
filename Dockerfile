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
	&& git checkout -q 34b23c28712ca644634079b50774c2002c798f3f
WORKDIR /init8js
RUN npm install
RUN cp -r node_modules /lib/
RUN cp log.js /lib/node_modules/

# install vccjs
WORKDIR /
RUN git clone https://github.com/hpchud/vccjs.git \
	&& cd vccjs \
	&& git checkout -q 061b71290b03ffc10e86b6ad663e4a8c56895087
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
