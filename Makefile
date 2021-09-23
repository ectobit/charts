.PHONY: gen-chart-docs lint

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
