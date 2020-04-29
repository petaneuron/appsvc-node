FROM mcr.microsoft.com/oryx/node:10-20190708.2
LABEL maintainer="Azure App Services Container Images <appsvc-images@microsoft.com>"

RUN echo "ipv6" >> /etc/modules

RUN mkdir -p /home/LogFiles /opt/startup \
     && echo "root:Docker!" | chpasswd \
     && echo "cd /home" >> /etc/bash.bashrc \
     && apt-get update \  
     && apt-get install --yes --no-install-recommends \
      openssh-server \
      vim \
      curl \
      wget \
      tcptraceroute \
      openrc \
      yarn \
      net-tools \
      dnsutils \
      tcpdump \
      iproute2
# setup default site
RUN rm -f /etc/ssh/sshd_config
COPY startup /opt/startup
COPY hostingstart.html /opt/startup
COPY startup.sh /opt/startup

# configure startup
RUN mkdir -p /tmp
COPY sshd_config /etc/ssh/

COPY ssh_setup.sh /tmp
RUN chmod -R +x /opt/startup \
   && chmod -R +x /tmp/ssh_setup.sh \
   && (sleep 1;/tmp/ssh_setup.sh 2>&1 > /dev/null) \
   && rm -rf /tmp/* \
   && echo "cd /home" >> /root/.bashrc \
   && cd /opt/startup \
   && npm install 

ENV PORT 8080
ENV SSH_PORT 2222
EXPOSE 2222 8080

ENV PM2HOME /pm2home

ENV WEBSITE_ROLE_INSTANCE_ID localRoleInstance
ENV WEBSITE_INSTANCE_ID localInstance
ENV PATH ${PATH}:/home/site/wwwroot

WORKDIR /home/site/wwwroot

ENTRYPOINT ["/opt/startup/init_container.sh"]
