FROM jenkins/inbound-agent:latest

USER root

# Install required packages and Docker
RUN apt-get update && \
    apt-get install -y ca-certificates curl gnupg lsb-release && \
    install -m 0755 -d /etc/apt/keyrings && \
    curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc && \
    chmod a+r /etc/apt/keyrings/docker.asc && \
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null && \
    apt-get update && \
    apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin && \
    systemctl enable docker.service && \
    systemctl enable containerd.service && \
    apt-get install -y wget && \
    rm -rf /var/lib/apt/lists/*

# Set permissions for Jenkins user
RUN usermod -aG docker jenkins && \
    usermod -aG docker $USER && \
    docker run hello-world


USER jenkins
