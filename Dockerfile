FROM amd64/python:3.7-alpine
LABEL maintainer="www.jonnyan404.top:8088"
ENV PYTHONUNBUFFERED=0 \
    TZ=Asia/Shanghai
COPY files/ /tmp
WORKDIR /app
RUN  set -x \
    && apk add --no-cache git tzdata zlib-dev freetype-dev jpeg-dev chromium mariadb-dev postgresql-dev \
    && apk add --no-cache --virtual .build-deps build-base g++ gcc libxslt-dev python2-dev linux-headers \
    && git clone https://github.com/zmister2016/MrDoc.git \
    && mv -f /tmp/files/config.ini MrDoc/config/ \
    && mv -f /tmp/files/editormd.css MrDoc/static/editor.md/css/ \
    && cd MrDoc \
    && pip install -r requirements.txt \
    && pip install mysqlclient \
    && python manage.py makemigrations \
    && python manage.py migrate \
    && echo "from django.contrib.auth import get_user_model; User = get_user_model(); User.objects.create_superuser('admin', 'www@jonnyan404.top', 'password')" | python manage.py shell \
    && apk del .build-deps \
    && rm -rf /var/cache/apk/*

WORKDIR /app/MrDoc
ENTRYPOINT ["python","-u","manage.py","runserver","--noreload"]
CMD ["0.0.0.0:10086"]