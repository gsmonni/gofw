BINARY_NAME=gofw
BINARY_FOLDER=release

build: # build ${BINARY_NAME}
	$(shell mkdir ${BINARY_FOLDER})
	GOARCH=amd64 GOOS=darwin go build -o ${BINARY_FOLDER}/${BINARY_NAME}-darwin ./cmd/main.go
	GOARCH=amd64 GOOS=linux go build -o  ${BINARY_FOLDER}/${BINARY_NAME}-linux ./cmd/main.go
	GOARCH=amd64 GOOS=windows go build -o  ${BINARY_FOLDER}/${BINARY_NAME}-windows ./cmd/main.go

run: build
	./${BINARY_FOLDER}/${BINARY_NAME}-darwin

clean:
	go clean
	rm -rf ${BINARY_FOLDER}

test:
	go test ./... -gcflags=all=-l

vendor:
	go mod vendor

first-time: clean vendor test run