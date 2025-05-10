# syntax=docker/dockerfile:1

FROM alpine:edge as build

RUN apk update
RUN apk add lua5.1 lua5.1-dev luarocks5.1 gcc build-base
RUN luarocks-5.1 install lua-cjson && \
  luarocks-5.1 install luasocket

WORKDIR /app
COPY . .

RUN luac -o build.luac **/*.lua

CMD ["lua", "build.luac"]

EXPOSE 3000
