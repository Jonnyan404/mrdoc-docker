FROM amd64/python:3.7-alpine
LABEL maintainer="www.mrdoc.fun"
ENV PYTHONUNBUFFERED=0 \
    TZ=Asia/Shanghai \
    LISTEN_PORT=10086 \
    USER=admin
COPY files/ /app
WORKDIR /app
RUN  set -x \
    && apk add wqy-zenhei --update-cache --repository  http://dl-3.alpinelinux.org/alpine/edge/testing/ --allow-untrusted \
    && apk add --no-cache --virtual .build-deps build-base g++ gcc libxslt-dev python2-dev linux-headers \
    && apk add --no-cache pwgen git tzdata zlib-dev freetype-dev jpeg-dev  mariadb-dev postgresql-dev \
    && python -m pip install --upgrade pip \
    && git clone https://github.com/zmister2016/MrDoc.git \
    && cd MrDoc \
    && pip --no-cache-dir install -r requirements.txt \
    && pip --no-cache-dir install mysqlclient \
    && python manage.py makemigrations \
    && mv /app/mrdoc.sh /app/MrDoc \
    && chmod +x mrdoc.sh \
    && apk del .build-deps \
    && rm -rf /var/cache/apk/*

WORKDIR /app/MrDoc
ENTRYPOINT ["./mrdoc.sh"]
