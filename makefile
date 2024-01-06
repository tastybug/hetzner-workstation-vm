# variables
ifeq ($(shell uname -s), Darwin)
        USER_HOME := /Users/$(shell whoami)
else
        USER_HOME := /home/$(shell whoami)
endif
ifeq ($(shell ! test -d $(USER_HOME)/.hetzner && echo missing), missing)
        $(error folder ~/hetzner folder required)
endif
ifeq ($(shell ! test -f $(USER_HOME)/.hetzner/token && echo missing), missing)
	$(error file ~/.hetzner/token required)
endif
ifeq ($(shell ! test -f $(USER_HOME)/.ssh/ansible.pub && echo missing), missing)
    $(error file ~/.ssh/ansible.pub required)
endif
ifeq ($(shell ! test -f $(USER_HOME)/.ssh/ansible && echo missing), missing)
    $(error file ~/.ssh/ansible required)
endif
SSH_DIR := $(USER_HOME)/.ssh
HETZNER_KEY := $(shell cat $(USER_HOME)/.hetzner/token)


.PHONY: plan apply destroy connect init
plan:
	terraform plan -var hcloud_token=$(HETZNER_KEY)
apply:
	terraform apply -var hcloud_token=$(HETZNER_KEY)
destroy:
	terraform destroy -var hcloud_token=$(HETZNER_KEY)
connect:
	ssh-keygen -R $(shell terraform output -raw instance_ip)
	ssh-add $(USER_HOME)/.ssh/ansible
	ssh $(shell whoami)@$(shell terraform output -raw instance_ip)
init:
	terraform init
