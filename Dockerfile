FROM joaoasrosa/packer-goss:1.3.3
LABEL maintainers="João Rosa <joaoasrosa@gmail.com>"

ENV AWS_CLI_VERSION=1.16.80

RUN apk update && apk upgrade
RUN apk add --update --no-cache --virtual .build-deps
RUN apk add make curl openssh

RUN ln -sf /usr/share/zoneinfo/Etc/UTC /etc/localtime

RUN apk -Uuv add groff less python py-pip
RUN pip install awscli

ENTRYPOINT ["/bin/packer"]