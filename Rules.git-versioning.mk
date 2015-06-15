# Id: git-versioning/0.0.27-master Rules.git-versioning.mk

include $(DIR)/Rules.git-versioning.shared.mk


empty :=
space := $(empty) $(empty)
usage::
	@echo 'usage:'
	@echo '# make [$(subst $(space),|,$(STRGT))]'


# Build a tar from the local files. Tagging the build causes Travis to
# upload the package to the github releases.

SRC += Makefile Rules.$(APP_ID).mk Rules.$(APP_ID).shared.mk .travis.yml \
			 Makefile.default-goals \
			 ReadMe.rst \
			 package.yaml package.json \
			 Sitefile.yaml \
			 lib/git-versioning.sh \
			 lib/formats.sh \
			 bin/ tools/
#			 reader.rst \

CLN += $(APP_ID)-$(VERSION).tar
TRGT += $(APP_ID)-$(VERSION).tar

$(APP_ID)-$(VERSION).tar: $(SRC) $(filter-out %.tar,$(TRGT))
	tar cvjf $@ $^


# Include a list of tasks with build
TRGT += TODO.list
CLN += TODO.list
TODO.list: $(SRC)
	-grep -srI 'TODO\|FIXME\|XXX' $^ | grep -v 'grep..srI..TODO' | grep -v 'TODO.list' > $@


# not sure where to keep these.. DEPs, build..

#DEP += .cli-version-update
.cli-version-update: ReadMe.rst $(shell echo $$(cat .versioned-files.list ))
	@echo $@ Because $?
	./bin/cli-version.sh update
	touch $@


TEST += cli-version-check
cli-version-check::
	./bin/cli-version.sh check


STRGT += do-release
do-release:: min := 
do-release:: maj := 
do-release::
do-release:: M=Release
do-release:: cli-version-check
	[ -n "$(VERSION)" ] || exit 1
	git ci -m "$(M) $(VERSION)"
	git tag $(VERSION)
	git push origin
	git push --tags
	./bin/cli-version.sh increment $(min) $(maj)
	./tools/cmd/prep-version.sh
	@git add $$(echo $$(cat .versioned-files.list))

# install/uninstall
V_SH_SHARE := /usr/local/share/git-versioning

INSTALL += $(V_SH_SHARE)

$(V_SH_SHARE):
	@test -n "$(V_SH_SHARE)"
	@test ! -e "$(V_SH_SHARE)"
	@mkdir -p $@/
	@cp -vr bin/ $@/bin; chmod +x $@/bin/*
	@cp -vr lib/ $@/lib
	@cp -vr tools/ $@/tools; chmod +x $@/tools/*/*.sh
	@cd /usr/local/bin/;pwd;ln -vs $(V_SH_SHARE)/bin/cli-version.sh git-versioning

STRGT += uninstall reinstall

uninstall::
	@test -n "$(V_SH_SHARE)"
	@test -e "$(V_SH_SHARE)"
	@rm -vf /usr/local/bin/git-versioning
	@P=$$(dirname $(V_SH_SHARE))/$$(basename $(V_SH_SHARE)); \
	 [ "$P" != "/" ] && rm -rfv $$P

reinstall:: uninstall install

test-run::
	git-versioning

