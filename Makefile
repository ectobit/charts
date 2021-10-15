.PHONY: gen-chart-docs lint update-deps

lint:
	helm lint vanity
	helm lint rspamd
	helm lint adminer

gen-chart-docs:
	helm-docs vanity
	prettier -w vanity/README.md
	helm-docs rspamd
	prettier -w rspamd/README.md
	helm-docs adminer
	prettier -w adminer/README.md

update-deps:
	cd rspamd && helm dependency update && cd -
