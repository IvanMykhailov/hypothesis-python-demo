# Project custom goalss

python_version := 3.7

# output list of awailable targets by default
.PHONY: list
list:
	@$(MAKE) -pRrq -f $(lastword $(MAKEFILE_LIST)) : 2>/dev/null | awk -v RS= -F: '/^# File/,/^# Finished Make data base/ {if ($$1 !~ "^[#.]") {print $$1}}' | sort | egrep -v -e '^[^[:alnum:]]' -e '^$@$$'


bundle:
	mkdir -p dist
	git archive --format=zip HEAD > dist/care-automation-`git rev-parse --short HEAD`.zip

.venv:
	# install virtualenv lib
	python${python_version} -m pip install virtualenv --user
	# create virtual env
	python${python_version} -m virtualenv --python=python${python_version} .venv
	# install installation-time deps and then regular deps
	source .venv/bin/activate &&\
		pip install -r requirements.txt

pip-requirements: .venv
	source .venv/bin/activate &&\
		pip install -r requirements.txt

lint: .venv
	source .venv/bin/activate &&\
		mypy . &&\
		pylint application.py

start-jupyter: .venv
	source .venv/bin/activate &&\
		jupyter notebook
