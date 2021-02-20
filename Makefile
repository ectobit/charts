.PHONY: gen-chart-docs lint

lint:
	helm lint vanity
	helm lint rspamd

gen-chart-docs:
	helm-docs vanity
	helm-docs rspamd
