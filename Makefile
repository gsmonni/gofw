.PHONY: help
help: # Show help for each of the Makefile recipes.
	@grep -E '^[a-zA-Z0-9 -]+:.*#'  Makefile | sort | while read -r l; do printf "\033[1;32m$$(echo $$l | cut -f 1 -d':')\033[00m:$$(echo $$l | cut -f 2- -d'#')\n"; done

BINARY_NAME=gofw
BINARY_FOLDER=release
VERSION=$(shell cat VERSION)

build: clean # build  gofw
	$(shell mkdir ${BINARY_FOLDER})
	go build -o ${BINARY_FOLDER}/${BINARY_NAME} ./cmd/main.go

run: build # build and run  gofw
	./${BINARY_FOLDER}/${BINARY_NAME}

clean: # clean-up binary files
	go clean
	rm -rf ${BINARY_FOLDER}

test: # run tests
	go test ./... -gcflags=all=-l -p=1

vendor: # pull vendor diectories
	go mod vendor

publish:
	#git tag ${VERSION} main
	git push origin ${VERSION}

first-time: clean vendor test run # run this command to pull all dependencies (this should be run only once)