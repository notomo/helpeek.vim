test:
	THEMIS_VIM=nvim THEMIS_ARGS="-e -s --headless" themis --exclude ./test/_data
	THEMIS_VIM=vim THEMIS_ARGS="-e -s" themis --exclude ./test/_data

doc:
	gevdoc --externals ./example/examples.vim ./doc/introduction

.PHONY: test
.PHONY: doc
