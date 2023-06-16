.PHONY: gen-chart-docs lint update-deps

lint:
	helm lint adminer
	helm lint budgie
	helm lint pgweb
	helm lint rspamd

gen-chart-docs:
	helm-docs
	prettier -w adminer/README.md
	prettier -w budgie/README.md
	prettier -w pgweb/README.md
	prettier -w rspamd/README.md

update-deps:
	cd rspamd && helm dependency update && cd -
