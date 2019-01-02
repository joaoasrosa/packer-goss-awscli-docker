FROM alpine:3.8
LABEL maintainers="João Rosa <joaoasrosa@gmail.com>"

ENV AWS_CLI_VERSION=1.16.81
ENV CFN_LINT_VERSION=0.10.2
ENV PACKER_VERSION=1.3.3
ENV PACKER_SHA256SUM=efa311336db17c0709d5069509c34c35f0d59c63dfb05f61d4572c5a26b563ea
ENV PACKER_PROVISIONER_GOSS_VERSION=0.3.0

RUN apk --no-cache update && \
    apk --no-cache upgrade

RUN apk --no-cache add python py-pip py-setuptools ca-certificates groff less && \
    pip --no-cache-dir install awscli==${AWS_CLI_VERSION} cfn-lint=={CFN_LINT_VERSION} && \
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

ENTRYPOINT ["/bin/packer"]