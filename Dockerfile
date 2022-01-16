FROM ubuntu:20.04
COPY xbvr /usr/bin/xbvr

EXPOSE 9998-9999
VOLUME /root/.config/

CMD ["/usr/bin/xbvr"]
