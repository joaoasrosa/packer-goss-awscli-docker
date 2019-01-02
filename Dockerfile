FROM joaoasrosa/packer-goss:1.3.3
LABEL maintainers="João Rosa <joaoasrosa@gmail.com>"

ENV AWS_CLI_VERSION=1.16.81
ENV S3CMD_VERSION=2.0.1

RUN apk update && apk upgrade

RUN apk -v --update add \
        python \
        py-pip \
        groff \
        less \
        mailcap \
        && \
    pip install awscli==1.16.81 s3cmd python-magic && \
    apk -v --purge del py-pip && \
    rm /var/cache/apk/*

RUN ls -l /usr/lib/python2.7/*/pyexpat*

ENTRYPOINT ["/bin/packer"]