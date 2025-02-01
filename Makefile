LOCAL_BIN:=$(CURDIR)/bin

install-deps:
	GOBIN=$(LOCAL_BIN) go install google.golang.org/protobuf/cmd/protoc-gen-go@v1.28.1
	GOBIN=$(LOCAL_BIN) go install -mod=mod google.golang.org/grpc/cmd/protoc-gen-go-grpc@v1.2

get-deps:
	go get -u google.golang.org/protobuf/cmd/protoc-gen-go
	go get -u google.golang.org/grpc/cmd/protoc-gen-go-grpc

generate:
	make generate-note-api

generate-note-api:
	mkdir -p pkg/note/v1
	protoc --proto_path api/note/v1 \
	--go_out=pkg/note/v1 --go_opt=paths=source_relative \
	--plugin=protoc-gen-go=bin/protoc-gen-go \
	--go-grpc_out=pkg/note/v1 --go-grpc_opt=paths=source_relative \
	--plugin=protoc-gen-go-grpc=bin/protoc-gen-go-grpc \
	api/note/v1/note.proto

build:
	GOOS=linux GOARCH=amd64 go build -o service_linux cmd/grpc_server/main.go

copy-to-server:
	scp service_linux root@82.148.5.107:

docker-build-and-push:
	docker buildx build --no-cache --platform linux/amd64 -t <REGISTRY>/test-server:v0.0.1 .
	docker login -u <USERNAME> -p <PASSWORD> <REGISTRY>
	docker push <REGISTRY>/test-server:v0.0.1

docker-build-and-push-unsafe:
	docker buildx build --no-cache --platform linux/amd64 -t registry.gitlab.com/orejametov/golang-temp/test-server:v0.0.1 .
	docker login -u orejametov -p 4moki4moki registry.gitlab.com/orejametov/golang-temp
	docker pull registry.gitlab.com/orejametov/golang-temp/test-server:v0.0.1