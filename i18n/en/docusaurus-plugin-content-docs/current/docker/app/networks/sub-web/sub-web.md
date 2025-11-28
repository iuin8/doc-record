# subweb

Subdescription transformation

[前端仓库地址](https://github.com/CareyWang/sub-web?tab=readme-ov-file#install)
[后端仓库地址](https://github.com/tindy2013/subconverter)

```bash
# Front employment
docker run -d -p 58080:80 --restart ways --name subweb careong/subweb:latest
# Backend employment
docker run -d --restore=always -p 25500:25500 tindy2013/subverter:latest
```
