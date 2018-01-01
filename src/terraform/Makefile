export PROJECT_ROOT ?= $(realpath $(CURDIR)/../..)
include ../../config.mk

export TF_DATA_DIR            := $(TERRAFORM_BUILD_DIR)/.terraform
export TF_PLAN_FILE           := $(TERRAFORM_BUILD_DIR)/terraform.tfplan
export TF_STATE_FILE          := $(TERRAFORM_STATE_DIR)/terraform.tfstate
export TF_VAR_project_name    := $(PROJECT)
export TF_VAR_ssh_private_key := $(SSH_KEY_DIR)/id_rsa
export TF_VAR_ssh_public_key  := $(SSH_KEY_DIR)/id_rsa.pub

.PHONY: check-code
check-code: $(TF_DATA_DIR)
	terraform validate -check-variables=false

.PHONY: build
build: $(TF_PLAN_FILE)

.PHONY: check-build
check-build: $(TF_PLAN_FILE)
	terraform validate

.PHONY: install
install: $(TF_STATE_FILE)

.PHONY: check-install
check-install:
	PUBLIC_IP=$$( terraform state show -state=$(TF_STATE_FILE) aws_instance.default | awk '/^public_ip/ {print $$3}' ) && \
	SSH_PRIVATE_KEY_FILE=$$( terraform output -state=$(TF_STATE_FILE) ssh_private_key ) && \
	SSH_USER=$$( terraform output -state=$(TF_STATE_FILE) ssh_user ) && \
	ssh -i $$SSH_PRIVATE_KEY_FILE -l $$SSH_USER -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null $$PUBLIC_IP uname -a

.PHONY: uninstall
uninstall:
	cd $(TERRAFORM_STATE_DIR) && terraform destroy -force
	rm -rf $(TERRAFORM_STATE_DIR)

.PHONY: clean
clean:
	rm -rf $(TERRAFORM_BUILD_DIR)

.DEFAULT:
	@exit 0

$(TF_DATA_DIR): terraform.tf
	mkdir -p $(TERRAFORM_BUILD_DIR)
	terraform init

$(TF_PLAN_FILE): terraform.tf $(TF_DATA_DIR)
	terraform plan -out=$(TF_PLAN_FILE) -state=$(TF_STATE_FILE)

$(TF_STATE_FILE): $(TF_PLAN_FILE)
	mkdir -p $(TERRAFORM_STATE_DIR)
	terraform apply -state-out=$(TF_STATE_FILE) $(TF_PLAN_FILE)
	PUBLIC_IP=$$( terraform state show -state=$(TF_STATE_FILE) aws_instance.default | awk '/^public_ip/ {print $$3}' ) && \
	SSH_PRIVATE_KEY_FILE=$$( terraform output -state=$(TF_STATE_FILE) ssh_private_key ) && \
	SSH_USER=$$( terraform output -state=$(TF_STATE_FILE) ssh_user ) && \
	ssh -i $$SSH_PRIVATE_KEY_FILE -l $$SSH_USER -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null $$PUBLIC_IP uname -a
