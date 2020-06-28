# ---------------------------------------------------
# Nuclear
# ---------------------------------------------------

AUTHOR			= rob-v
PACKAGE			= nuke_utils
VERSION 		= 0.2.0
DESCRIPTION 	= Nuke artist assist tools and scripts

# ---------------------------------------------------
# Config
# ---------------------------------------------------

#NUKE.ROOT = ./python
#NUKE.FILES = $(shell find $(NUKE.ROOT) -type f -name "*.py")

# ---------------------------------------------------
# Nuke
# ---------------------------------------------------

NUKE.ROOT = ./nuke
NUKE.FILES = $(shell find $(NUKE.ROOT) -type f -name "*.py")

# ---------------------------------------------------
# Python
# ---------------------------------------------------

#SCRIPTS.ROOT = ""
#SCRIPTS.FILES = $(shell find $(SCRIPTS.ROOT) -type f -name "*.py")


# ---------------------------------------------------
# Resources
# ---------------------------------------------------

#SCRIPTS.ROOT = ""
#SCRIPTS.FILES = $(shell find $(SCRIPTS.ROOT) -type f -name "*")

# ---------------------------------------------------
# Scripts
# ---------------------------------------------------

#SCRIPTS.ROOT = ""
#SCRIPTS.FILES = $(shell find $(SCRIPTS.ROOT) -type f -name "*")


# ---------------------------------------------------
# Rules
# ---------------------------------------------------

.PHONY: test

all: clean test install

clean:
	@echo Cleaning the .build directory
	@rm -f -r .build

scripts:
	@echo Installing scripts to $(TEMP)
	@rm -r -f $(TEMP)
	@if [ $(SCRIPTS.FILES) ]; then\
		@mkdir -p $(TEMP);\
		@install -v -m $(MODE) $(SCRIPTS.FILES) $(TEMP);\
	else \
		echo "No scripts to install, continue...";\
	fi

scripts-install:
	$(eval TEMP=$(shell echo /software/scripts/$(PACKAGE)/ | tr A-Z a-z))
	$(eval MODE=555)
	@echo "In here"
	$(make scripts)

scripts-test:
	$(eval TEMP=$(shell echo .build/scripts/$(PACKAGE)/ | tr A-Z a-z))
	$(eval MODE=744)

python:
	@echo Installing Python Module to $(TEMP)
	@rm -r -f $(TEMP)
	@mkdir -p $(TEMP)
	@for PY in $(NUKE.FILES); do \
		echo "compiling and copying $$PY -> $(TEMP)" ; \
		python -m py_compile $$PY ; \
		v=$${PY%/*} ; \
		v=$(TEMP)$${v#./nuke} ; \
		mkdir -p $$v ; \
		install -v -m $(MODE) $$PY $$v ; \
	done
	@echo "Completed..."

python-install:
	$(eval TEMP=$(shell echo /software/tools/nuke/$(PACKAGE)/$(VERSION)))
	$(eval MODE=444)

python-test:
	$(eval TEMP=$(shell echo .build/nuke/$(PACKAGE)/$(VERSION)))
	$(eval MODE=644)

test:
	@echo "in here"
	$(make scripts-test)
	$(make scripts)

install: clean scripts-install scripts python-install python

deploy-check:
	@# Check if there are commits that need to be complete
	$(eval STATUS=$(shell git status --porcelain))
	@if [  ! "$(STATUS)" ]; then\
		git status;\
		echo "\n\033[1mPlease commit changes before executing deploy!\033[0m";\
		exit 1; \
	else \
		git tag -f v$(VERSION);\
		git push;\
		git push --tags -f;\
	fi

deploy: scripts-test scripts scripts-install scripts python-install python
	-@unlink "/software/tools/nuke/$(PACKAGE)/latest"
	-@ln -s $(TEMP) "/software/tools/nuke/$(PACKAGE)/latest"

