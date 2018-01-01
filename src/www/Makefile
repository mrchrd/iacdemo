export PROJECT_ROOT ?= $(realpath $(CURDIR)/../..)
include ../../config.mk

.PHONY: build
build:
	mkdir -p $(HTML_DIR)
	cp -Rp $(CURDIR)/html/* $(HTML_DIR)/

.PHONY: check-install
check-install:
	PUBLIC_IP=$$( terraform state show -state=$(TERRAFORM_STATE_DIR)/terraform.tfstate aws_instance.default | awk '/^public_ip/ {print $$3}' ) && \
	curl -fLsS http://$$PUBLIC_IP/ | grep "Hello World!"

.PHONY: clean
clean:
	rm -rf $(HTML_DIR)

.DEFAULT:
	@exit 0
