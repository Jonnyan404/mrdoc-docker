>  项目地址:<https://github.com/zmister2016/MrDoc>

> 本项目用runserver运行,如需uwsgi/nginx方式运行, https://hub.docker.com/r/jonnyan404/mrdoc-nginx

> 另外:已支持 `arm64` 平台,例如:树莓派/斐讯N1

详细教程: [docker版本简明使用教程](https://www.jonnyan404.top:8088/archives/mrdoc%E7%9A%84docker%E7%89%88%E6%9C%AC%E7%AE%80%E6%98%8E%E4%BD%BF%E7%94%A8%E6%95%99%E7%A8%8B)
---

## 一、简单使用教程

`docker run -d --name mrdoc -p 10086:10086 jonnyan404/mrdoc`

- 默认端口：10086
- 默认用户：admin
- 默认密码：password

 打开 `http://IP:10086` 即可访问.

## 二、挂载本地目录
- 最新挂载，支持sql目录和配置文件挂载，不再依赖源代码。

1.在本地挂载目录 vim config.ini

```
[site]
# True表示开启站点调试模式，False表示关闭站点调试模式
debug = False

[database]
# engine，指定数据库类型，接受sqlite、mysql、oracle、postgresql
engine = sqlite
# name表示数据库的名称
# name = db_name
# user表示数据库用户名
# user = db_user
# password表示数据库用户密码
# password = db_pwd
# host表示数据库主机地址
# host = db_host
# port表示数据库端口
[chromium]
# path用于指定Chromium的路径，不指定则使用默认的
path = /usr/lib/chromium/chrome
args = --no-sandbox,--disable-gpu

```

2.运行容器
`docker run -d --name mrdoc -p 10086:10086 -v ~/mrdoc:/app/MrDoc/config jonnyan404/mrdoc`

3.生成数据库文件

`docker exec -it mrdoc python manage.py migrate`

`docker exec -it mrdoc python manage.py createsuperuser`

按提示输入管理员账号邮箱密码

~~因为是整个目录挂载,所以需要你本地有从 github 下载的所有源码文件,否则会因找不到启动文件而启动失败,(0.5.1版本以前如下操作)
`docker run -d --name mrdoc -p 10086:10086 -v ~/mrdoc:/app/MrDoc jonnyan404/mrdoc`~~

## 三、自定义端口
`docker run -d --name mrdoc -p xxx:port  -v ~/mrdoc:/app/MrDoc/config jonnyan404/mrdoc-alpine 0.0.0.0:port`

- xxx 为宿主机端口
- port 为容器端口

自行替换 xxx 与 port 即可.
