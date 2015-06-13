# Id: git-versioning/0.0.16-master Rules.git-versioning.shared.mk
# special rule targets
STRGT += \
   version \
   path release tag \
   publish

version:
	@./bin/cli-version.sh version

check::
	@$(echo) -n "Checking for $(APP_ID) version "
	@./bin/cli-version.sh check

patch:
	@./bin/cli-version.sh increment

release: maj := 
release:
	@./bin/cli-version.sh increment true $(maj)

tag:
	@git tag $(APP_ID)/$$(./bin/cli-version.sh version)
	@echo "New tag: $(APP_ID)/$$(./bin/cli-version.sh version)"
	@./bin/cli-version.sh increment
	@./tools/cmd/prep-version.sh


# XXX: GIT publish
publish: DRY := yes
publish: check
	@[ -z "$(VERSION)" ] && exit 1 || echo Publishing $(./bin/cli-version.sh version)
	git push
	@if [ $(DRY) = 'no' ]; \
	then \
		git tag v$(VERSION)
		git push fury master; \
		npm publish --tag $(VERSION); \
		npm publish; \
	else \
		echo "*DRY* $(VERSION)"; \
	fi

TRGT += package2.json

package2.json: package.yaml
	yaml2json $< > $@

