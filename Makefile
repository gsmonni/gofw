.PHONY: help
help: # Show help for each of the Makefile recipes.
	@grep -E '^[a-zA-Z0-9 -]+:.*#'  Makefile | sort | while read -r l; do printf "\033[1;32m$$(echo $$l | cut -f 1 -d':')\033[00m:$$(echo $$l | cut -f 2- -d'#')\n"; done

APP_NAME=gofw
BINARY_NAME=gofw
BINARY_FOLDER=release
VERSION=$(shell cat VERSION)

build: clean # build  gofw for local system
	$(shell mkdir ${BINARY_FOLDER})
	go build -o ${BINARY_FOLDER}/${BINARY_NAME} ./cmd/main.go

build-linux: clean test # build  gofw for linux system
	$(shell mkdir ${BINARY_FOLDER})
	GOOS=linux go build -o ${BINARY_FOLDER}/${BINARY_NAME} ./cmd/main.go

run: build # build and run  gofw
	./${BINARY_FOLDER}/${BINARY_NAME}

run-linux: build-linux # build and run  gofw
	./${BINARY_FOLDER}/${BINARY_NAME}

clean: # clean-up binary files
	go clean
	rm -rf coverage.out
	rm -rf ${BINARY_FOLDER}

test: # run tests
	go test -gcflags=all=-l -p=1 ./...

coverage: $(shell find . -type f -print | grep -v vendor | grep "\.go")
	@go test -cover -coverprofile ./coverage.out ./...

cover: coverage # compute code coverage
	@go tool cover -html=./coverage.out

vendor: # pull vendor directories
	go mod vendor

publish:
	#git tag ${VERSION} main
	git push origin ${VERSION}

docker-run: ## Build the container
	docker build -t $(APP_NAME) -f Dockerfile .
	docker run -it --rm -v .:/$(APP_NAME) --name="$(APP_NAME)" $(APP_NAME)

first-time: clean vendor test run # run this command to pull all dependencies (this should be run only once)

first-time-linux: clean vendor test build-linux # run this command to pull all dependencies (this should be run only once)