FROM alpine:3.18

ENV CURL_VERSION="8.5.0-r0"
ENV KUBECTL_VERSION="1.28.4"

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Setup prerequisites
RUN apk add --update --no-cache \
  curl=${CURL_VERSION}

# Setup kubectl
RUN curl -LO \
  "https://dl.k8s.io/release/v${KUBECTL_VERSION}/bin/linux/amd64/kubectl" \
  && chmod +x kubectl \
  && curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl.sha256" \
  && echo "$(cat kubectl.sha256)  kubectl" | sha256sum -c \
  && mv kubectl /usr/local/bin/kubectl

# Secure image
RUN adduser -D worker
USER worker
WORKDIR /home/worker

LABEL maintainer="David Abarca david.abarca@mechaconsulting.org" \
  version="1.0.0"
