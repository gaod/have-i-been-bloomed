#!/bin/bash

# download pwned passwords file
pwned-passwords-sha1-ordered-by-hash-v5.7z:
	wget https://downloads.pwnedpasswords.com/passwords/pwned-passwords-sha1-ordered-by-hash-v5.7z

# create the Bloom filter
pwned-passwords-5.0.bloom: pwned-passwords-sha1-ordered-by-hash-v5.7z
	bloom --gzip create -p 1e-6 -n 555278657 pwned-passwords-5.0.bloom
	7z x pwned-passwords-sha1-ordered-by-hash-v5.7z -so | awk -F":" '{print tolower($1)}' | bloom insert pwned-passwords-5.0.bloom

bloom-filter: pwned-passwords-5.0.bloom

bloom-tool:
	go get github.com/adewes/bloom
	go install github.com/adewes/bloom

server:
	go get ./...
	go install ./...

all: bloom-tool server bloom-filter

.DEFAULT_GOAL := all
