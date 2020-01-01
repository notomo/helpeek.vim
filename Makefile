test:
	THEMIS_VIM=nvim THEMIS_ARGS="-e -s --headless" themis --exclude ./test/_data
	THEMIS_VIM=vim THEMIS_ARGS="-e -s" themis --exclude ./test/_data

.PHONY: test
