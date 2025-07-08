# specify the node base image with your desired version node:<version>
FROM node:lts
# replace this with your application's default port
EXPOSE 4321

WORKDIR /usr/bin
RUN wget "https://github.com/jqlang/jq/releases/download/jq-1.7.1/jq-linux-amd64"  && mv jq-linux-amd64 jq && chmod 755 jq

RUN mkdir /my-astro-project
WORKDIR /my-astro-project

RUN npm init --yes

RUN npm install astro

RUN jq 'del(.scripts)' package.json > package.json.tmp && mv package.json.tmp package.json
RUN jq '.scripts += {dev: "astro dev", build: "astro build", preview: "astro preview"}' package.json > package.json.tmp && mv package.json.tmp package.json

RUN npm create astro@latest -- --template minimal

RUN mkdir -p src/pages

COPY pages/* /my-astro-project/src/pages/index.astro
COPY scripts/* /my-astro-project

# Default command
ENTRYPOINT ["/my-astro-project/start.sh"]