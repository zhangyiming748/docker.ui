FROM golang:1.23.4-alpine3.21 as build
# RUN sed -i 's#https\?://dl-cdn.alpinelinux.org/alpine#http://mirrors4.tuna.tsinghua.edu.cn/alpine#g' /etc/apk/repositories
RUN apk add build-base git libc-dev gcc
ADD . /app
WORKDIR /app
ENV GO111MODULE=on
# ENV GOPROXY="https://goproxy.cn,direct"
RUN go mod tidy
RUN go mod download
RUN go build -o server .


FROM alpine:3.21.0

WORKDIR /app
COPY --from=build /app/server /app
COPY ./log4go.xml /app
COPY ./data.db /app
COPY ./html /app/html
LABEL AUTHOR="joinsunsoft"
LABEL LANGUAGE="golang"
LABEL PRODUCT="docker"
LABEL COPYRIGHT="joinsunsoft"
LABEL DECLAIM="All right reserved by joinsunsoft"

RUN  mkdir /lib64 && ln -s /lib/libc.musl-x86_64.so.1 /lib64/ld-linux-x86-64.so.2

EXPOSE 8889

ENTRYPOINT  ["./server"]
