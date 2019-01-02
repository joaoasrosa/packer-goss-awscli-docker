FROM joaoasrosa/packer-goss:1.3.3
LABEL maintainers="João Rosa <joaoasrosa@gmail.com>"

ENV AWS_CLI_VERSION=1.16.81

RUN apk --no-cache update && \
    apk --no-cache upgrade

RUN apk --no-cache add python py-pip py-setuptools ca-certificates groff less && \
    pip --no-cache-dir install awscli==${AWS_CLI_VERSION} && \
    rm -rf /var/cache/apk/*

RUN aws --version

ENTRYPOINT ["/bin/packer"]