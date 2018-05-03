FROM alpine:edge as dl

RUN apk add --update wget
RUN mkdir -p /opt ;\
	cd /opt ;\
	wget https://github.com/snail007/goproxy/releases/download/v4.7/proxy-linux-amd64.tar.gz ;\
	tar zxvf proxy-linux-amd64.tar.gz ;\
	rm -f proxy-linux-amd64.tar.gz

FROM alpine:edge

COPY --from=dl /opt/proxy /bin/proxy
COPY --from=dl /opt/blocked /etc/proxy/blocked
COPY --from=dl /opt/direct /etc/proxy/direct

EXPOSE 1080

CMD ["/bin/proxy", "http", "-t", "tcp", "-p", "0.0.0.0:1080"]


# docker run --rm -it --net host  -p 1080:1080 ttt proxy http -p ":1080" -t tcp --debug -g 167.88.181.133
