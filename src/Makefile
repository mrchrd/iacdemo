export PROJECT_ROOT ?= $(realpath $(CURDIR)/..)
include ../config.mk

.PHONY: check-code
check-code:
	@$(MAKE) $(MAKE_FLAGS) -C $(SRC_DIR)/terraform check-code
	@$(MAKE) $(MAKE_FLAGS) -C $(SRC_DIR)/ansible check-code

.PHONY: build
build:
	@$(MAKE) $(MAKE_FLAGS) -C $(SRC_DIR)/ssh-keys build
	@$(MAKE) $(MAKE_FLAGS) -C $(SRC_DIR)/terraform build
	@$(MAKE) $(MAKE_FLAGS) -C $(SRC_DIR)/www build

.PHONY: check-build
check-build: build
	@$(MAKE) $(MAKE_FLAGS) -C $(SRC_DIR)/ssh-keys check-build
	@$(MAKE) $(MAKE_FLAGS) -C $(SRC_DIR)/terraform check-build
	@$(MAKE) $(MAKE_FLAGS) -C $(SRC_DIR)/www check-build

.PHONY: install
install: build
	@$(MAKE) $(MAKE_FLAGS) -C $(SRC_DIR)/terraform install
	@$(MAKE) $(MAKE_FLAGS) -C $(SRC_DIR)/ansible install

.PHONY: check-install
check-install: build
	@$(MAKE) $(MAKE_FLAGS) -C $(SRC_DIR)/terraform check-install
	@$(MAKE) $(MAKE_FLAGS) -C $(SRC_DIR)/ansible check-install
	@$(MAKE) $(MAKE_FLAGS) -C $(SRC_DIR)/www check-install

.PHONY: uninstall
uninstall:
	@$(MAKE) $(MAKE_FLAGS) -C $(SRC_DIR)/terraform uninstall
	rm -rf $(STATE_DIR)

.PHONY: clean
clean: build
	@$(MAKE) $(MAKE_FLAGS) -C $(SRC_DIR)/www clean
	@$(MAKE) $(MAKE_FLAGS) -C $(SRC_DIR)/terraform clean
	@$(MAKE) $(MAKE_FLAGS) -C $(SRC_DIR)/ssh-keys clean
	rm -rf $(BUILD_DIR)
