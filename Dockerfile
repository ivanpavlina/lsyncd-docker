FROM alpine:3.20

RUN apk update
RUN apk --no-cache add openssh rsync lsyncd dcron
ADD ./entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
