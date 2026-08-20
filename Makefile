.PHONY: gen-chart-docs lint test-adminer

lint:
	helm lint adminer

test-adminer:
	bash adminer/tests/render-postgresql-tls.sh

gen-chart-docs:
	helm-docs --chart-search-root adminer
	prettier -w adminer/README.md
