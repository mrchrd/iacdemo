FROM hadolint/hadolint:v1.2.4 AS hadolint
FROM debian:stretch

ARG ANSIBLE_VERSION=2.4.2
ARG HADOLINT_VERSION=1.2.4
ARG TERRAFORM_VERSION=0.11.1
ARG TERRAFORM_INVENTORY_VERSION=0.7-pre

LABEL description="Infrastructure as Code Tools" \
      maintainer="Michael Richard <michael.richard.ing@gmail.com>" \
      ansible_version="${ANSIBLE_VERSION}" \
      hadolint_version="${HADOLINT_VERSION}" \
      terraform_version="${TERRAFORM_VERSION}" \
      terraform_inventory_version="${TERRAFORM_INVENTORY_VERSION}"

ENV DEBIAN_FRONTEND noninteractive

# Install common tools
RUN apt-get update -q -y && \
    apt-get install -q -y --no-install-recommends \
            ca-certificates=\* \
            curl=\* \
            dirmngr=\* \
            git=\* \
            gnupg=\* \
            make=\* \
            openssh-client=\* \
            unzip=\* \
            vim-tiny=\* \
            && \
    apt-get autoremove -q -y --purge \
            && \
    apt-get clean -q -y && \
    rm -rf /tmp/* && \
    rm -rf /var/lib/apt/lists/* && \
    rm -rf /var/tmp/*

# Install Ansible
RUN apt-key adv \
            --keyserver keyserver.ubuntu.com \
            --recv-keys 93C4A3FD7BB9C367 \
            && \
    echo 'deb http://ppa.launchpad.net/ansible/ansible/ubuntu trusty main' > /etc/apt/sources.list.d/ansible.list && \
    apt-get update -q -y && \
    apt-get install -q -y --no-install-recommends \
            "ansible=${ANSIBLE_VERSION}*" \
            && \
    apt-get autoremove -q -y --purge \
            && \
    apt-get clean -q -y && \
    rm -rf /tmp/* && \
    rm -rf /var/lib/apt/lists/* && \
    rm -rf /var/tmp/*


# Install Terraform
RUN curl -fLsS -o /tmp/terraform.zip "https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip" && \
    unzip -d /usr/local/bin /tmp/terraform.zip && \
    chmod u=rwx,g=rx,o=rx /usr/local/bin/terraform && \
    rm -rf /tmp/*

# Install terraform-inventory for Ansible
RUN curl -fLsS -o /tmp/terraform-inventory.zip "https://github.com/adammck/terraform-inventory/releases/download/v${TERRAFORM_INVENTORY_VERSION}/terraform-inventory_v${TERRAFORM_INVENTORY_VERSION}_linux_amd64.zip" && \
    unzip -d /usr/local/bin /tmp/terraform-inventory.zip && \
    chmod u=rwx,g=rx,o=rx /usr/local/bin/terraform-inventory && \
    rm -rf /tmp/*

# Install hadolint
COPY --from=hadolint /bin/hadolint /usr/local/bin/hadolint
