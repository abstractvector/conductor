# Compile of registry binaries
FROM arm32v7/golang as builder

ENV DOCKER_BUILDTAGS include_oss include_gcs

RUN apt-get update \
    && apt-get install --assume-yes make git \
    && git clone -b master https://github.com/docker/distribution.git /go/src/github.com/docker/distribution \
    && mkdir -p /etc/docker/registry && \
    cp /go/src/github.com/docker/distribution/cmd/registry/config-dev.yml /etc/docker/registry/config.yml \
    && make PREFIX=/go clean binaries

# Build a minimal distribution container
FROM arm32v7/debian:stretch

RUN apt-get update && \
    apt-get install -y ca-certificates librados2 apache2-utils && \
    rm -rf /var/lib/apt/lists/*

COPY --from=builder /go/bin/registry /bin/registry
COPY --from=builder /go/src/github.com/docker/distribution/cmd/registry/config-example.yml /etc/docker/registry/config.yml

VOLUME ["/var/lib/registry", "/etc/docker/registry/"]

EXPOSE 5000

ENTRYPOINT ["/bin/registry"]

CMD ["serve", "/etc/docker/registry/config.yml"]