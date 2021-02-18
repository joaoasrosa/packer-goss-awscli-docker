FROM alpine:3.13.2
LABEL maintainers="João Rosa <joaoasrosa@gmail.com>"

ENV AWS_CLI_VERSION=1.16.140
ENV CFN_LINT_VERSION=0.18.1
ENV PACKER_VERSION=1.4.0
ENV PACKER_SHA256SUM=7505e11ce05103f6c170c6d491efe3faea1fb49544db0278377160ffb72721e4
ENV PACKER_PROVISIONER_GOSS_VERSION=0.3.0
ENV PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

RUN apk --no-cache update && \
    apk --no-cache upgrade

RUN apk --no-cache add python py-pip py-setuptools ca-certificates groff less && \
    pip --no-cache-dir install awscli==${AWS_CLI_VERSION} cfn-lint==${CFN_LINT_VERSION} && \
    apk del py-pip && \
    rm -rf /var/cache/apk/*

RUN apk add --update --repository http://dl-cdn.alpinelinux.org/alpine/edge/main git bash wget openssl

ADD https://releases.hashicorp.com/packer/${PACKER_VERSION}/packer_${PACKER_VERSION}_linux_amd64.zip ./
ADD https://releases.hashicorp.com/packer/${PACKER_VERSION}/packer_${PACKER_VERSION}_SHA256SUMS ./

RUN sed -i '/.*linux_amd64.zip/!d' packer_${PACKER_VERSION}_SHA256SUMS
RUN sha256sum -cs packer_${PACKER_VERSION}_SHA256SUMS
RUN unzip packer_${PACKER_VERSION}_linux_amd64.zip -d /bin
RUN rm -f packer_${PACKER_VERSION}_linux_amd64.zip

ADD https://github.com/YaleUniversity/packer-provisioner-goss/releases/download/v${PACKER_PROVISIONER_GOSS_VERSION}/packer-provisioner-goss-v${PACKER_PROVISIONER_GOSS_VERSION}-linux-amd64 ./

RUN mv ./packer-provisioner-goss-v${PACKER_PROVISIONER_GOSS_VERSION}-linux-amd64 /bin/packer-provisioner-goss
RUN chmod +x /bin/packer-provisioner-goss

RUN apk add --update --repository http://dl-cdn.alpinelinux.org/alpine/edge/main jq

ENTRYPOINT ["/usr/bin/env"]