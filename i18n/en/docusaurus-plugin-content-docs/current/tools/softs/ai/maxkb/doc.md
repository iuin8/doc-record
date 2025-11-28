# maxkb use record

[官网安装目录](https://maxkb.cn/docs/installation/online_installtion/)

## Install

```bash
docker run -d --name=maxkb --staart=always -p 80:8080 -v ~/.maxkb:/var/lib/postprogresql/data -v ~/.python-packes://opt/maxkb/app/sandbox/python-packages registry.fit2cloud.com/maxkb/maxkb

```
