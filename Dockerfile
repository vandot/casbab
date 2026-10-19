FROM bash:5

LABEL org.opencontainers.image.source="https://github.com/vandot/casbab" \
      org.opencontainers.image.description="Convert between camelCase, snake_case, kebab-case and friends" \
      org.opencontainers.image.licenses="BSD-3-Clause"

COPY casbab.sh /usr/local/bin/casbab

ENTRYPOINT ["bash", "/usr/local/bin/casbab"]
