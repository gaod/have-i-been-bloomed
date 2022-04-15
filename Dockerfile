FROM golang:alpine AS builder
RUN apk add --no-cache git
COPY . /go/src/gitlab.kkinternal.com/gaodchen/have-i-been-bloomed
WORKDIR /go/src/gitlab.kkinternal.com/gaodchen/have-i-been-bloomed/cmd/hibb
RUN go get -d
RUN CGO_ENABLED=0 go build -a -installsuffix cgo -o /app

FROM alpine:3.15.4
COPY --from=builder /app /bin/hibb
COPY --from=builder /go/src/gitlab.kkinternal.com/gaodchen/have-i-been-bloomed/pwned-passwords-6.0.bloom /
ENTRYPOINT ["hibb"]
EXPOSE 8000
