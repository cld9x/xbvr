FROM alpine
COPY xbvr /usr/bin/xbvr

EXPOSE 9998-9999
VOLUME /root/.config/

ENTRYPOINT ["/usr/bin/xbvr"]
