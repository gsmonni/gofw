FROM golangci/build-runner
LABEL authors="gianstefanomonni"
COPY release/gofw /bin/gofw
ENTRYPOINT ["/bin/gofw"]