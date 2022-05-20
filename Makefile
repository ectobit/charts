.PHONY: gen-chart-docs lint update-deps

lint:
	helm lint vanity
	helm lint rspamd
	helm lint adminer
	helm lint pgweb
	helm lint pigeon

gen-chart-docs:
	helm-docs
	prettier -w vanity/README.md
	prettier -w rspamd/README.md
	prettier -w adminer/README.md
	prettier -w pgweb/README.md
	prettier -w pigeon/README.md

update-deps:
	cd rspamd && helm dependency update && cd -
