export PROJECT_ROOT ?= $(realpath $(CURDIR)/../..)
include ../../config.mk

SSH_PRIVATE_KEY := $(SSH_KEY_DIR)/id_rsa
SSH_PUBLIC_KEY  := $(SSH_KEY_DIR)/id_rsa.pub

.PHONY: build
build: $(SSH_PRIVATE_KEY) $(SSH_PUBLIC_KEY)

.PHONY: check-build
check-build: $(SSH_PRIVATE_KEY) $(SSH_PUBLIC_KEY)
	bash -c "diff -y <(ssh-keygen -e -f $(SSH_PRIVATE_KEY) -y) <(ssh-keygen -e -f $(SSH_PUBLIC_KEY) -y)"

.PHONY: clean
clean:
	rm -rf $(SSH_KEY_DIR)

.DEFAULT:
	@exit 0

$(SSH_PRIVATE_KEY) $(SSH_PUBLIC_KEY):
	mkdir -p $(SSH_KEY_DIR)
	ssh-keygen -C "$(PROJECT)" -f $(SSH_PRIVATE_KEY) -N ""
