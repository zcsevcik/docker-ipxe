FROM nginx:stable-alpine
CMD []

LABEL maintainer "zcsevcik@gmail.com"

COPY myscript.ipxe /tmp/
COPY supervisor.conf /etc/supervisord.conf
RUN apk --update --no-cache add tftp-hpa supervisor && \
    apk --update --no-cache add --virtual build-dependencies \
    git gcc binutils make perl syslinux xz-dev musl musl-utils musl-dev && \

    git clone --depth 1 git://git.ipxe.org/ipxe.git /usr/src/ipxe && \
    sed -i /usr/src/ipxe/src/config/console.h \
        -e 's|//#define[ \t]\+CONSOLE_FRAMEBUFFER|  #define\tCONSOLE_FRAMEBUFFER|' && \
    sed -i /usr/src/ipxe/src/config/general.h \
        -e 's|//#define CONSOLE_CMD|#define CONSOLE_CMD|' && \
    make -C /usr/src/ipxe/src bin/undionly.kpxe EMBED=/tmp/myscript.ipxe && \
    mkdir -p /usr/share/tftp/ && \
    cp -fv /usr/src/ipxe/src/bin/undionly.kpxe /usr/share/tftp/ && \
    rm -fr /usr/src/ipxe && \

    apk del build-dependencies

EXPOSE 69
CMD ["supervisord", "-c", "/etc/supervisord.conf"]

