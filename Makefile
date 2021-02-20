.PHONY: gen-chart-docs lint

lint:
	helm lint charts/vanity

gen-chart-docs:
	helm-docs charts/vanity
