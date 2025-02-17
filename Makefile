#!/bin/bash

# download pwned passwords file
pwned-passwords-sha1-ordered-by-hash-v8.7z:
	wget https://downloads.pwnedpasswords.com/passwords/pwned-passwords-sha1-ordered-by-hash-v8.7z

# create the Bloom filter
pwned-passwords-8.0.bloom: pwned-passwords-sha1-ordered-by-hash-v8.7z
	bloom --gzip create -p 1e-6 -n 572611621 pwned-passwords-8.0.bloom
	7z x pwned-passwords-sha1-ordered-by-hash-v8.7z -so | awk -F":" '{print tolower($$1)}' | bloom --gzip insert pwned-passwords-8.0.bloom

bloom-filter: pwned-passwords-8.0.bloom

bloom-tool:
	go get github.com/DCSO/bloom/...
	go install github.com/DCSO/bloom/...

server:
	go get ./...
	go install ./...

all: bloom-tool server bloom-filter

.DEFAULT_GOAL := all
