FROM wealthfolio/wealthfolio:3.8.0

ARG BUILD_ARCH
ARG BASHIO_VERSION=0.19.0
ARG S6_OVERLAY_VERSION=3.1.6.2

ENV \
	S6_BEHAVIOUR_IF_STAGE2_FAILS=2 \
	S6_CMD_WAIT_FOR_SERVICES=1 \
	S6_CMD_WAIT_FOR_SERVICES_MAXTIME=0 \
	S6_SERVICES_GRACETIME=0

USER root

RUN apk add --no-cache argon2 bash ca-certificates curl jq nginx xz openssl \
	&& S6_ARCH="${BUILD_ARCH}" \
	&& if [ "${BUILD_ARCH}" = "amd64" ]; then S6_ARCH="x86_64"; fi \
	&& curl -fsSL "https://github.com/just-containers/s6-overlay/releases/download/v${S6_OVERLAY_VERSION}/s6-overlay-noarch.tar.xz" | tar -xJp -C / \
	&& curl -fsSL "https://github.com/just-containers/s6-overlay/releases/download/v${S6_OVERLAY_VERSION}/s6-overlay-${S6_ARCH}.tar.xz" | tar -xJp -C / \
	&& mkdir -p /tmp/bashio \
	&& curl -fsSL "https://github.com/hassio-addons/bashio/archive/v${BASHIO_VERSION}.tar.gz" | tar -xz --strip-components=1 -C /tmp/bashio \
	&& mv /tmp/bashio/lib /usr/lib/bashio \
	&& ln -s /usr/lib/bashio/bashio /usr/bin/bashio \
	&& rm -rf /tmp/bashio

COPY rootfs /

ENTRYPOINT ["/init"]

HEALTHCHECK \
	--interval=30s \
	--retries=3 \
	--start-period=15s \
	--timeout=10s \
	CMD curl --fail --silent http://127.0.0.1:8089/ >/dev/null || exit 1
