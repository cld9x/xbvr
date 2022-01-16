FROM alpine
COPY xbvr /usr/bin/xbvr
RUN mkdir /root/.config

EXPOSE 9998-9999
VOLUME /root/.config/

ENTRYPOINT ["/usr/bin/xbvr"]
