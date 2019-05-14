WORKDIR := $(shell pwd)

edx_runtime_dir?=$(shell cat .dir_info/edx_runtime_dir || echo "./../KT-edx-runtime")
edx_runtime_repo_url?=git@github.com:flying-pi/KT-edx-runtime.git
edx_runtime_branch?=release-0.0.1

edx_image_dir?=$(shell cat .dir_info/edx_image_dir || echo "./../KT-image-lib")
edx_image_repo_url?=git@github.com:flying-pi/KT-image-lib.git
edx_image_repo_branch?=release-0.0.1


help: ## Display help message
	@echo "Please use \`make <target>' where <target> is one of"
	@perl -nle'print $& if m{^[\.a-zA-Z_-]+:.*?## .*$$}' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m  %-25s\033[0m %s\n", $$1, $$2}'

clone: clone_edx_runtime clone_image_repo

clone_edx_runtime: .dir_info
	git clone $(edx_runtime_repo_url)  $(edx_runtime_dir) -b $(edx_runtime_branch)
	touch .dir_info/edx_runtime_dir
	echo $(edx_runtime_dir) > .dir_info/edx_runtime_dir

clone_image_repo: .dir_info
	git clone $(edx_runtime_repo_url)  $(edx_image_dir) -b $(edx_image_repo_branch)
	touch .dir_info/edx_image_dir
	echo $(edx_image_dir) > .dir_info/edx_image_dir

.dir_info:
	mkdir -p  .dir_info