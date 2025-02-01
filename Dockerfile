FROM golang:1.23-alpine as builder

COPY . /github.com/rejametov/golang_lessons/week-2/grpc/source/
WORKDIR /github.com/rejametov/golang_lessons/week-2/grpc/source/

RUN go mod download
RUN go build -o ./bin/crud_server cmd/grpc_server/main.go

FROM alpine:latest

WORKDIR /root/
COPY --from=builder /github.com/rejametov/golang_lessons/week-2/grpc/source/bin/crud_server .

CMD ["./crud_server"]