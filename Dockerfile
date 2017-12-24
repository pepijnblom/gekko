FROM golang:alpine as golang
RUN apk add --no-cache build-base git && \
    go get github.com/tj/node-prune/cmd/node-prune

FROM node:8-alpine as build
WORKDIR /usr/src/app
COPY package*.json ./
COPY --from=golang /go/bin/node-prune /usr/local/bin/
RUN set -x && \
    apk add --no-cache python build-base && \
    npm install -g --production node-gyp && \
    npm install --production && \
    npm install --production redis@0.10.0 talib@1.0.2 tulind@0.8.7 pg && \
    du -h && \
    node-prune && \
    du -h
    
FROM node:8-alpine
# Set environment vars
ENV HOST localhost
ENV PORT 3000
ENV WORKDIR /app
EXPOSE 3000
# Prepare the application
WORKDIR ${WORKDIR}
COPY . .
COPY --from=build /usr/src/app/node_modules/ /app/node_modules/
RUN set -x && \
    apk add --no-cache tini &&  \
    ./configureUI.sh
ENTRYPOINT [ "/sbin/tini", "-v", "--" ]
CMD [ "node", "gekko.js", "--config", "config.js", "--ui" ]
