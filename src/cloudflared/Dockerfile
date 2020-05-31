FROM alpine:latest

# Install cloudflared
# The libc6-compat lib can be required for example dynamically linked programs written in GO language, like cloudflared
RUN apk --no-cache add libc6-compat ca-certificates \
    && mkdir -p /opt/cloudflared/ \
    && wget -qO - https://bin.equinox.io/c/VdrWdbjqyF/cloudflared-stable-linux-arm.tgz | tar --directory=/usr/local/bin/ -xz \
    && chmod +x /usr/local/bin/cloudflared \
    && adduser -S -D -H cloudflared

USER cloudflared
VOLUME ["/cloudflared_config"]
ENTRYPOINT ["/usr/local/bin/cloudflared"]
CMD ["--config", "/cloudflared/config.yml"]
