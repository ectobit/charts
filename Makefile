.PHONY: gen-chart-docs lint test-adminer test-rspamd update-deps

lint:
	helm lint adminer
	helm lint pgweb
	helm lint rspamd

test-adminer:
	bash adminer/tests/render-postgresql-tls.sh

test-rspamd:
	bash rspamd/tests/render-external-redis.sh

gen-chart-docs:
	helm-docs
	prettier -w adminer/README.md
	prettier -w pgweb/README.md
	prettier -w rspamd/README.md

update-deps:
	cd rspamd && helm dependency update && cd -
