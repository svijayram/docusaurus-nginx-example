#### STAGE 1: Build ####
FROM node:16-alpine3.14 as builder

WORKDIR /usr/src/my-doc-app
COPY package*.json  ./

RUN npm install --silent

COPY . .

RUN npm run build
RUN ls && pwd 

### STAGE 2: Setup ###
FROM nginx:1.20.2

ARG USER_UID=9999
ARG USER_GID=$USER_UID

WORKDIR /usr/share/nginx/html

RUN rm -rf ./*

COPY --from=builder /usr/src/my-doc-app/build /usr/share/nginx/html
COPY --from=builder /usr/src/my-doc-app/build/my-doc-portal/index.html /usr/share/nginx/html/index.html
COPY ./nginx.conf /etc/nginx/conf.d/default.conf


EXPOSE 80
RUN ls && pwd
CMD ["/bin/bash", "-c", "nginx -g \"daemon off;\""]
