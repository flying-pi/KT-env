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
	git clone $(edx_image_repo_url)  $(edx_image_dir) -b $(edx_image_repo_branch)
	touch .dir_info/edx_image_dir
	echo $(edx_image_dir) > .dir_info/edx_image_dir

build_base_edx: .build/images/base_edx


build_edx_runtime: .build/images/edx_runtime
run_edex_runtime: build_edx_runtime
	docker run -it -v $$(pwd)$(edx_runtime_dir)/:/runtime_app -p 5937:5937 kt/edx_runtime:v-0.0.1

.build/images/edx_runtime: .build .build/images/base_edx
	docker build -t kt/edx_runtime:v-0.0.1 -f $(edx_runtime_dir)/docker/Dokcerfile.python2.dev $(edx_runtime_dir)
	touch $@

.build/images/base_edx: .build
	docker build -t kt/base_edx:v-10.0 $(edx_image_dir)/edx/v-10.0/
	touch $@

.dir_info:
	mkdir -p  .dir_info

.build:
	mkdir .build
	mkdir .build/images

torrr:
	echo $$(pwd)$(edx_runtime_dir)

# TODO move imagenames to the variable
