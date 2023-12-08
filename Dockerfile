FROM alpine:3.18

ENV CURL_VERSION="8.5.0-r0"
ENV KUBECTL_VERSION="1.28.4"

ENV PROJECT_VERSION="1.0.0"
ENV PROJECT_AUTHOR="David Abarca"
ENV PROJECT_EMAIL="david.abarca@mechaconsulting.org"

SHELL ["/bin/ash", "-o", "pipefail", "-c"]

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

LABEL maintainer="${PROJECT_AUTHOR} ${PROJECT_EMAIL}" \
  version=${PROJECT_VERSION}
