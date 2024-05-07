FROM node:20-alpine AS node

FROM alpine:latest

ENV PYTHONUNBUFFERED=1
ENV PIP_BREAK_SYSTEM_PACKAGES 1
WORKDIR /usr/src

ARG PRODUCT=terraform
ARG VERSION=1.8.0

COPY --from=node /usr/lib /usr/lib
COPY --from=node /usr/local/lib /usr/local/lib
COPY --from=node /usr/local/include /usr/local/include
COPY --from=node /usr/local/bin /usr/local/bin

COPY ./entrypoint.sh .

RUN chmod +x /usr/src/entrypoint.sh

RUN apk add --update --no-cache gnupg npm wget bash openssl ncurses-libs libstdc++ python3 py3-pip && \
  ln -sf python3 /usr/bin/python && \
  cd /tmp && \
  wget https://releases.hashicorp.com/${PRODUCT}/${VERSION}/${PRODUCT}_${VERSION}_linux_amd64.zip && \
  wget https://releases.hashicorp.com/${PRODUCT}/${VERSION}/${PRODUCT}_${VERSION}_SHA256SUMS && \
  wget https://releases.hashicorp.com/${PRODUCT}/${VERSION}/${PRODUCT}_${VERSION}_SHA256SUMS.sig && \
  wget -qO- https://www.hashicorp.com/.well-known/pgp-key.txt | gpg --import && \
  gpg --verify ${PRODUCT}_${VERSION}_SHA256SUMS.sig ${PRODUCT}_${VERSION}_SHA256SUMS && \
  grep ${PRODUCT}_${VERSION}_linux_amd64.zip ${PRODUCT}_${VERSION}_SHA256SUMS | sha256sum -c && \
  unzip /tmp/${PRODUCT}_${VERSION}_linux_amd64.zip -d /tmp && \
  mv /tmp/${PRODUCT} /usr/local/bin/${PRODUCT} && \
  rm -f /tmp/${PRODUCT}_${VERSION}_linux_amd64.zip ${PRODUCT}_${VERSION}_SHA256SUMS ${VERSION}/${PRODUCT}_${VERSION}_SHA256SUMS.sig

RUN pip3 install --no-cache --upgrade pip setuptools
RUN npm install -g npm@latest && npm install -g cdktf-cli@latest

ENTRYPOINT ["/usr/src/entrypoint.sh"]
