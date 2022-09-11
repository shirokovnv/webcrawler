#!/usr/bin/make
# Makefile readme (en): <https://www.gnu.org/software/make/manual/html_node/index.html#SEC_Contents>

dc_bin := $(shell command -v docker-compose 2> /dev/null)
docker_bin := $(shell command -v docker 2> /dev/null)

SHELL = /bin/sh

.PHONY : help init \
         shell test \
         up down fix \
         pull
.SILENT : help
.DEFAULT_GOAL : help

# This will output the help for each task. thanks to https://marmelab.com/blog/2016/02/29/auto-documented-makefile.html
help: ## Show this help
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

shell: ## Start shell into phoenix container
	$(dc_bin) run phoenix sh

init: ## Install all app dependencies
	$(dc_bin) run --no-deps phoenix mix deps.get

test: ## Execute app tests
	$(dc_bin) run phoenix mix test

up: ## Create and start containers
	$(dc_bin) up --detach --remove-orphans

down: ## Destroy all running containers
	$(dc_bin) down

fix: ## Execute formatter
	$(dc_bin) run --user "0:0" --no-deps phoenix mix format

pull: ## Pull latest images
	$(dc_bin) pull