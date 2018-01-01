include config.mk

.PHONY: build
.DEFAULT build:
	@$(MAKE) $(MAKE_FLAGS) -C $(SRC_DIR) $(MAKECMDGOALS)
