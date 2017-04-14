FROM nginx:stable-alpine
LABEL maintainer "zcsevcik@gmail.com"

COPY myscript.ipxe /tmp/
RUN apk --update --no-cache add tftp-hpa supervisor && \
    apk --update --no-cache add --virtual build-dependencies \
    git gcc binutils make perl syslinux xz-dev musl musl-utils musl-dev && \

    git clone --depth 1 git://git.ipxe.org/ipxe.git /usr/src/ipxe && \
    make -C /usr/src/ipxe/src bin/undionly.kpxe EMBED=/tmp/myscript.ipxe && \
    mkdir -p /usr/share/tftp/ && \
    cp -fv /usr/src/ipxe/src/bin/undionly.kpxe /usr/share/tftp/ && \
    rm -fr /usr/src/ipxe && \

    apk del build-dependencies

EXPOSE 69
COPY supervisor.conf /etc/supervisor.conf
CMD ["supervisord", "-c", "/etc/supervisor.conf"]

