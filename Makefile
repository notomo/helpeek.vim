test:
	THEMIS_VIM=nvim THEMIS_ARGS="-e -s --headless" $(MAKE) _test
	THEMIS_VIM=vim THEMIS_ARGS="-e -s" $(MAKE) _test

_test:
	themis --exclude ./test/_data

doc:
	gevdoc --externals ./doc/examples.vim ./doc/introduction

.PHONY: test
.PHONY: doc
