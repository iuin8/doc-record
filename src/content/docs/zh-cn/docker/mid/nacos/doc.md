# nacos记录

## docker部署

[官网快速开始](https://nacos.io/docs/latest/quickstart/quick-start-docker/?spm=5238cd80.72a042d5.0.0.5bc0cd361NMDsf)

生成jwt secrets用于NACOS_AUTH_TOKEN

```bash
# Linux / macOS
openssl rand -base64 32
# Python 3
python -c "import base64, secrets; print(base64.b64encode(secrets.token_bytes(32)).decode())"
# Windows PowerShell
[Convert]::ToBase64String((New-Object byte[] 32).ForEach({[byte](Get-Random -Minimum 0 -Maximum 256)}))
```

```bash
docker run --name nacos-standalone-derby \
    -e MODE=standalone \
    -e NACOS_AUTH_TOKEN=Y3J5cHRvX3NlY3VyZV9rZXlfZm9yX25hY29zX2p3dF90b2tlbl8xMjM0NTY3ODkwYWJjZGVmZ2g= \
    -e NACOS_AUTH_IDENTITY_KEY=nacos \
    -e NACOS_AUTH_IDENTITY_VALUE=nacos \
    -p 8080:8080 \
    -p 8848:8848 \
    -p 9848:9848 \
    -d nacos/nacos-server:latest
```
