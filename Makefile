CONTAINER_IP = $(shell docker inspect --format '{{ .NetworkSettings.IPAddress }}' charlesbot.org)

.PHONY: help
help:
	@echo Start with "make hugo" and go from there

.PHONY: go
go:
	go get -v github.com/spf13/hugo

themes: go
	mkdir -p themes
	cd themes; git clone https://github.com/digitalcraftsman/hugo-strata-theme.git || true
	cd themes/hugo-strata-theme; git reset --hard bca3b7b12aebd206dae445f4415c88ee59f215f3

travis-linkchecker:
	linkchecker http://127.0.0.1:8080

server: clean themes
	@echo ===========================================================
	@echo Head over to http://$(CONTAINER_IP):8080 for a live preview
	@echo ===========================================================
	hugo server \
		--bind="0.0.0.0" \
		--port=8080 \
		--baseUrl="http://$(CONTAINER_IP)" \
		--watch

travis-server:
	hugo server \
		--bind="127.0.0.1" \
		--port=8080 \
		--baseUrl="http://127.0.0.1" \
		--watch=false

.PHONY: generate
generate: clean themes
	hugo

.PHONY: clean
clean:
	rm -rf public
	rm -f Gemfile.lock

.PHONY: clean-all
clean-all: clean
	rm -rf themes
	rm -rf /tmp/go
