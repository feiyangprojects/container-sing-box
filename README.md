## Sing-Box

### Overview

Minimalistic Sing-Box container image based on Apline linux.

### Build

```
ARGS=()
for i in $(find ./VERSIONS/ -type f); do
  ARGS+=('--build-arg' "${i##*/}=$(< $i)")
done
docker build "${ARGS[@]}" --tag ${PWD##*/} \
       --label org.opencontainers.image.created="$(date --rfc-3339 seconds --utc)" \
       --label org.opencontainers.image.version=$(< DISPLAY_VERSION) \
       --label org.opencontainers.image.revision=$(git rev-parse HEAD) .
```

Push image to registry:

```
docker tag ${PWD##*/} $CONTAINER_REGISTRY_USERNAME/${PWD##*/}:$(< DISPLAY_VERSION)
docker tag ${PWD##*/} $CONTAINER_REGISTRY_USERNAME/${PWD##*/}:latest
docker push --all-tags $CONTAINER_REGISTRY_USERNAME/${PWD##*/}
```

### Environment variables

| Name | Default value | Description |
| --- | --- | --- |


### Run

```
docker run --detach \
       --network host \
       --restart always \
       --env KEY=VALUE \
       --volume $PATH_TO_CONFIG:/config \
       ghcr.io/fei1yang/sing-box:latest
```

To configure a Sing-Box client or server, please refer to [it's document](https://sing-box.sagernet.org/) for further details.

Note: [Podman](https://podman.io/) is recommended for use this container image due to its amazing automatic update feature, please refer to the [official document](https://docs.podman.io/en/latest/markdown/podman-auto-update.1.html) for further details.
