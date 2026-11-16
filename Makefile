# rzone is a raz module a program builds with its own raz, reaching it
# with -I rzone/src; nothing here is a program. Its tests build with
# the raz on PATH, which must be the version the module is written
# for, RAZVERSION: make warns of any other. Its tarball is on raz's
# website, at download/raz-$(RAZVERSION)-linux-x86_64.tar.gz.

RAZ ?= raz
CC ?= cc
RAZVERSION = 0.25.0
RAZSITE = https://raz.lucela.org
# Build and test from this checkout only, never the copy `make install` put on RAZ_PATH.
export RAZ_PATH :=
# raz's tools, the formatter among them, lie beside its real path
RAZTOOLS = $(dir $(realpath $(shell command -v $(RAZ))))tools

ifneq "$(word 2,$(shell $(RAZ) --version 2>/dev/null))" "$(RAZVERSION),"
$(warning rzone is written for raz $(RAZVERSION), from $(RAZSITE); $(RAZ) is $(or $(shell $(RAZ) --version 2>/dev/null),not found))
endif
PREFIX = $(HOME)/.local

build:
	mkdir -p build

# the module's main is its test; then Zone against the C library's
# localtime_r, zone by zone, with test/slim.zi's zones made by zic
check: | build
	$(RAZ) -Werror -o build/Zone src/Zone.raz
	build/Zone
	$(CC) -O2 -Wall -Werror -o build/glibc test/glibc.c
	zic -b slim -d build/zi test/slim.zi
	$(RAZ) -Werror -I src -o build/Glibc test/Glibc.raz
	build/Glibc

# the sources are as raz's formatter lays them out
fmt: | build
	$(RAZ) -o build/Pretty $(RAZTOOLS)/Pretty.raz
	@fail=0; for f in src/*.raz test/*.raz; do \
	    build/Pretty $$f | cmp -s - $$f || { echo "not formatted: $$f"; fail=1; }; \
	done; test $$fail = 0

# lines, by rloc; a measure, not a limit
loc:
	@rloc src test/*.raz

# Where `make install` puts the modules, for programs to import with no -I: raz(1), RAZ_PATH.
RAZLIB ?= $(HOME)/.raz/lib
MODULES = $(wildcard src/*.raz)

# the page and the modules
install:
	mkdir -p $(PREFIX)/share/man/man3
	cp doc/rzone.3 $(PREFIX)/share/man/man3/rzone.3
	mkdir -p $(RAZLIB)
	install -m644 $(MODULES) $(RAZLIB)
	echo 0.25 > $(RAZLIB)/RAZ-VERSION

uninstall:
	rm -f $(PREFIX)/share/man/man3/rzone.3
	rm -f $(addprefix $(RAZLIB)/,$(notdir $(MODULES)))

clean:
	rm -rf build

.PHONY: check fmt loc install uninstall clean
