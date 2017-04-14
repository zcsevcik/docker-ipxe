FROM nginx:stable-alpine
LABEL maintainer "zcsevcik@gmail.com"

COPY myscript.ipxe /tmp/
RUN apk --update --no-cache add --virtual build-dependencies \
    git gcc binutils make perl syslinux xz-dev && \
    apk --update --no-cache add tftp-hpa && \

    git clone --depth 1 git://git.ipxe.org/ipxe.git /usr/src/ipxe && \
    make -C /usr/src/ipxe/src bin/undionly.kpxe EMBED=/tmp/myscript.ipxe && \
    mkdir -p /usr/share/ipxe/ && \
    cp -v /usr/src/ipxe/src/bin/undionly.kpxe /usr/share/ipxe/ && \
    rm -fr /usr/src/ipxe && \

    apk del build-dependencies

EXPOSE 69
