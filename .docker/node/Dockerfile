ARG NODE_VERSION
FROM node:${NODE_VERSION}
LABEL maintainer="Osiozekhai Aliu"

ENV USER=node
ENV GROUP=node
ENV PASSWORD=eTahdee1ei
ENV PATH=/home/node/node_modules/.bin:/home/node/.npm-global/bin:$PATH

RUN apk update && apk upgrade \
    && apk add shadow sudo make g++ git openssh openssl bash dirmngr bash-completion nano tzdata python3 \
    && rm -rf /var/cache/apk/* \
    && chmod +x /usr/local/bin/* \
    && chown -R $USER:$GROUP /home/$USER

RUN echo 'node ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers