export PROJECT_ROOT ?= $(realpath $(CURDIR)/../..)
include ../../config.mk

export TF_STATE := $(TERRAFORM_STATE_DIR)/terraform.tfstate

.PHONY: check-code
check-code:
	ansible-playbook -e "nginx_html_src=$(HTML_DIR)" --syntax-check playbook.yml

.PHONY: install
install:
	ansible-playbook -e "nginx_html_src=$(HTML_DIR)" playbook.yml

.PHONY: check-install
check-install:
	ansible-playbook -e "nginx_html_src=$(HTML_DIR)" --check --diff playbook.yml

.DEFAULT:
	@exit 0
