FROM golang:alpine AS builder
RUN apk add --no-cache git
COPY . /go/src/gitlab.kkinternal.com/ccnchien/have-i-been-bloomed
WORKDIR /go/src/gitlab.kkinternal.com/ccnchien/have-i-been-bloomed/cmd/hibb
RUN go get -d
RUN CGO_ENABLED=0 go build -a -installsuffix cgo -o /app

FROM alpine:3.10
COPY --from=builder /app /bin/hibb
ENTRYPOINT ["hibb"]
EXPOSE 8000
