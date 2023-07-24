SHELL := /bin/bash

.Default_GOAL := help
.DEFAULT = .Default_GOAL

VENV = $(CURDIR)/.venv/bin/activate

$(VENV): $(CURDIR)/venv_package.txt
	python3.10  -m venv $(CURDIR)/.venv
	chmod 700 $(CURDIR)/.venv/bin/activate
	( \
		source $(CURDIR)/.venv/bin/activate; \
		pip install wheel; \
		pip install -r $(CURDIR)/venv_package.txt; \
	)
	
dev: ## Setup Local With VENV
	$(MAKE) $(VENV)

test:
	$(MAKE) $(VENV)
	( \
		source $(CURDIR)/.venv/bin/activate; \
		pytest $(CURDIR)/tests \
	)	


lint:
	$(MAKE) $(VENV)
	( \
		source $(CURDIR)/.venv/bin/activate; \
		flake8 --config=$(CURDIR)/setup.cfg $(CURDIR)/application/ \
	)


app-artifact:
	rm -rf $(CURDIR)/artifact
	mkdir -p $(CURDIR)/artifact
	rsync -av . artifact \
		--no-links \
		--exclude artifact/ \
		--exclude .vscode/ \
		--exclude .pytest_cache/ \
		--exclude .git/ \
		--exclude .coverage \
		--exclude .gitignore \
		--exclude setup.cfg \
		--exclude .coveragec \
		--exclude .venv/ \
		--exclude whitesource \
		--exclude README.md \


setup-env: ## Create necessary environment variables
	@export dummy=this/is/dummy/path

clean:
	rm -rf $(CURDIR)/.venv

help:
	@echo "\nTARGETS:\n"
	@make -qpRr | egrep -e '^[a-z].*:$$' | sed -e 's~:~~g' | sort
	@echo ""
