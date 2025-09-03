FROM ubuntu:22.04

# Base on the two Dockerfiles here: https://github.com/GoogleCloudPlatform/cloud-builders/tree/master/docker
RUN apt-get -y update && \
    apt-get -y install \
    apt-transport-https \
    ca-certificates \
    curl \
    make \
    software-properties-common && \
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | \
    gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg && \
    echo "deb [arch=$(dpkg --print-architecture) \
    signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] \
    https://download.docker.com/linux/ubuntu \
    $(lsb_release -cs) stable" > /etc/apt/sources.list.d/docker.list && \
    apt-get -y update && \
    apt-get -y dist-upgrade && \
    apt-get autoremove && \
    apt-get clean

# Install amazon-ecr-credential-helper
# To configure: https://github.com/awslabs/amazon-ecr-credential-helper?tab=readme-ov-file#configuration
# ecr-login is not configured because it conflicts with docker login commands https://github.com/awslabs/amazon-ecr-credential-helper/issues/102
RUN apt-get -y install \
    docker-ce \
    docker-ce-cli \
    docker-compose docker-compose-plugin \
    amazon-ecr-credential-helper && \
    apt-get clean

# Configure amazon-ecr-credential-helper
# Create docker config directory and set up credential helper
RUN mkdir -p /root/.docker && \
    echo '{"credsStore": "ecr-login"}' > /root/.docker/config.json

# Add amazon-ecr-credential-helper to PATH
ENV PATH="/usr/bin:$PATH"

ARG RAILPACK_VERSION
ENV RAILPACK_VERSION=${RAILPACK_VERSION}
RUN curl -fsSL https://railpack.com/install.sh | bash
