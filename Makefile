INSTALL_ARGS := $(if $(PREFIX),--prefix $(PREFIX),)
BIN := ./_build/default/bin/main.exe

default: boot.exe
	./boot.exe -j 4 --dev

boot.exe: bootstrap.ml
	ocaml bootstrap.ml

install:
	$(BIN) install $(INSTALL_ARGS)

uninstall:
	$(BIN) uninstall $(INSTALL_ARGS)

reinstall: uninstall reinstall

test:
	$(BIN) runtest

all-supported-ocaml-versions:
	$(BIN) build @install @runtest --workspace jbuild-workspace.dev --root .

clean:
	$(BIN) clean
	rm -f ./boot.exe

doc:
	cd doc && sphinx-build . _build

CMDS = $(shell $(BIN) --help=plain | \
  sed -n '/COMMANDS/,/OPTIONS/p' | sed -En 's/^       ([a-z-]+)/\1/p')

update-jbuilds: $(BIN)
	sed -n '1,/;;GENERATED/p' doc/jbuild > doc/jbuild.tmp
	{ for cmd in $(CMDS); do \
	    echo -ne "\n"\
	"(rule\n"\
	"  ((targets (jbuilder-$$cmd.1))\n"\
	"   (action  (with-stdout-to $$""{@}\n"\
	"             (run $$""{bin:jbuilder} $$cmd --help=groff)))))\n"\
	"\n"\
	"(install\n"\
	" ((section man)\n"\
	"  (files (jbuilder-$$cmd.1))))\n"; \
	  done } >> doc/jbuild.tmp
	rm -f doc/jbuild
	mv doc/jbuild.tmp doc/jbuild

.PHONY: default install uninstall reinstall clean test doc
