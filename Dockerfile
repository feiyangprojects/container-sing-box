FROM golang:alpine AS builder

ARG VERSION

RUN set -ex && cd / \
    && wget -O - "https://github.com/SagerNet/sing-box/archive/$VERSION.tar.gz" | tar xzf -
RUN set -ex && cd /sing-box-*/ \
    && CGO_ENABLED=0 go build -trimpath -v -o /usr/bin/sing-box -tags "with_quic,with_grpc,with_dhcp,with_wireguard,with_ech,with_utls,with_reality_server,with_clash_api,with_v2ray_api,with_gvisor" -ldflags " \
    -X 'github.com/sagernet/sing-box/constant.Version=$VERSION' \
    -w -s -buildid=" ./cmd/sing-box


FROM alpine:latest

LABEL org.opencontainers.image.authors "Fei Yang <projects@feiyang.eu.org>"
LABEL org.opencontainers.image.url https://github.com/feiyangprojects/container-sing-box
LABEL org.opencontainers.image.documentation https://github.com/feiyangprojects/container-sing-box/blob/main/README.md
LABEL org.opencontainers.image.source https://github.com/feiyangprojects/container-sing-box
LABEL org.opencontainers.image.vendor "FeiYang Labs"
LABEL org.opencontainers.image.licenses GPL-3.0-only
LABEL org.opencontainers.image.title Sing-Box
LABEL org.opencontainers.image.description "Minimalistic Sing-Box container image based on Apline linux."

RUN set -ex && mkdir -p /config /data /usr/share/sing-box \
    && wget -O /usr/share/sing-box/geoip.db https://github.com/SagerNet/sing-geoip/releases/latest/download/geoip.db \
    && wget -O /usr/share/sing-box/geosite.db https://github.com/SagerNet/sing-geosite/releases/latest/download/geosite.db

COPY --from=builder /usr/bin/sing-box /usr/bin/sing-box

VOLUME ["/config", "/data"]

WORKDIR /config

CMD ["/usr/bin/sing-box", "run", "-c", "/config/config.json"]
