FROM alpine:3.11
MAINTAINER Drew Short <warrick@sothr.com>

ARG rclone_version=v1.50.2
ARG rclone_arch=amd64

RUN apk update \
    && apk upgrade \
    && apk add --update bash curl unzip jq

RUN cd /tmp \
    && curl -O https://downloads.rclone.org/${rclone_version}/rclone-${rclone_version}-linux-${rclone_arch}.zip \
    && unzip rclone-${rclone_version}-linux-${rclone_arch}.zip \
    && cd rclone-${rclone_version}-linux-${rclone_arch} \
    && cp rclone /usr/bin/ \
    && chown root:root /usr/bin/rclone \
    && chmod 755 /usr/bin/rclone \
    && cd .. \
    && rm -f rclone-${rclone_version}-linux-${rclone_arch}.zip \
    && rm -rf rclone-${rclone_version}-linux-${rclone_arch}

COPY ./assets/* /opt/resource/

RUN chmod 755 /opt/resource/check \
    && chmod +x /opt/resource/in \
    && chmod +x /opt/resource/out