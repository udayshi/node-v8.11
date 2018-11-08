FROM debian:buster-slim
RUN apt-get update \
&& apt-get install -y \
	        bash \
	        wget \
            curl \
            git \
            vim \
	        supervisor \
	        nginx

ENV PATH=$PATH:/usr/local/node/bin/
#Node Installation
WORKDIR /usr/local/
RUN wget https://nodejs.org/dist/v8.11.3/node-v8.11.3-linux-x64.tar.xz && \
    tar xf node-v8.11.3-linux-x64.tar.xz && \
    rm -rf node-v8.11.3-linux-x64.tar.xz && \
    ln -sf node-v8.11.3-linux-x64 node
RUN npm i -g yarn



ENV TZ=Europe/London
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
COPY manifest/config/nginx.conf /etc/nginx/nginx.conf
COPY manifest/config/supervisord.conf /etc/supervisor/conf.d/supervisord.conf


COPY app /app
RUN mkdir -p /run/nginx/
WORKDIR /app
EXPOSE 80 443
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]