FROM ibmcom/mq:9
RUN useradd alice -G mqm && \
    echo alice:passw0rd | chpasswd
COPY config.mqsc /etc/mqm/

# Copy the Intercept distribution zip file from RTCP into the image
COPY IBMWebSphereMQdist.zip /tmp/intercept/

# Install unzip so that the Intercept can be extracted
RUN export DEBIAN_FRONTEND=noninteractive && \
    apt-get update -y && \
    apt-get install --no-install-recommends -y unzip && \
    unzip /tmp/intercept/IBMWebSphereMQdist -d /tmp/intercept/ && \
    \
# Move the 32-bit exit into /opt/intercept/exits with the correct ownership and permissions
    mkdir -p /opt/intercept/exits && \
    cd /opt/intercept/exits && \
    cp -t . /tmp/intercept/7.1-8.0/intercept_linux_x86 /tmp/intercept/7.1-8.0/intercept_linux_x86_r && \
    mv intercept_linux_x86 intercept && \
    mv intercept_linux_x86_r intercept_r && \
    chown mqm:mqm intercept* && \
    chmod a+x intercept* && \
    \
# Move the 64-bit exit into /opt/intercept/exits with the correct ownership and permissions
    mkdir -p /opt/intercept/exits64 && \
    cd /opt/intercept/exits64 && \
    cp -t . /tmp/intercept/7.1-8.0/intercept_linux_x86_64 /tmp/intercept/7.1-8.0/intercept_linux_x86_64_r && \
    mv intercept_linux_x86_64 intercept && \
    mv intercept_linux_x86_64_r intercept_r && \
    chown mqm:mqm intercept* && \
    chmod a+x intercept* && \
    \
# Clean up
    rm -fr /tmp/intercept && \
    rm -rf /var/lib/apt/lists/* && \
    \
# Inject into the container start script commands to append addendum_qm.ini to qm.ini and copy exits into the correct location.
# Unless it happens here the files are either not present when the broker starts or later replaced.
    sed -i 's#.*crtmqm.*#&\ncat /opt/intercept/addendum_qm.ini >> /var/mqm/qmgrs/${MQ_QMGR_NAME}/qm.ini\ncp /opt/intercept/exits/* /var/mqm/exits\ncp /opt/intercept/exits64/* /var/mqm/exits64#' /usr/local/bin/mq.sh
    
COPY addendum_qm.ini /opt/intercept/
