FROM joaoasrosa/packer-goss:1.3.3
LABEL maintainers="João Rosa <joaoasrosa@gmail.com>"

ENV AWS_CLI_VERSION=1.16.81

RUN apk update && apk upgrade

RUN apk -v --update add \
        python \
        py-pip \
        groff \
        less \
        mailcap \
        && \
    pip install awscli python-magic && \
    apk -v --purge del py-pip && \
    rm /var/cache/apk/*

ENTRYPOINT ["/bin/packer"]