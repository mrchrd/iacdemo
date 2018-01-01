#!/bin/sh

export TF_KEY_NAME=public_ip

terraform-inventory $@
