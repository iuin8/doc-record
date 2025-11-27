# ollama usage record

[官网](https://ollama.com)

## Install

```bash
curl -fsSL https://ollama.com/install.sh | sh
```

- docker version (only CPU)

[docker hub address] (https://hub.docker.com/r/ollama/ollama)

```bash
docker run -d -v tolama:/root/.ollama -p 11434:11434 --name olama olama/olama
```

## Use

```bash
olama run BAI/bge-reeranker-v2-m3
```
