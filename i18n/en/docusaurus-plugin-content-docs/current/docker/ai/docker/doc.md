# lm Deplot documentation in docker

[参考文章](https://www.docker.com/blog/llm-docker-for-local-and-hugging-face-hosting/)

## Example

```bash
docker run -it -p 7860:7860 --platform=linux/amd64 \
    -e HUGING_FACE_HUB_TOKEN="YOUR_VALUE_HERE"

    registry.hf.space/harsh-manvar-llama-2-7b-chat-test:latest python app.py

# Open brows and go to http://localhost:7860：
```

## Quick Start

```bash
git clone https://huggingface.co/space/harsh-manvar/llama-2-7b-chat-test
```

- Dockerfile

[Dockerfile来源](https://huggingface.co/spaces/harsh-manvar/llama-2-7b-chat-test/blob/main/Dockerfile)

```Dockerfile
FROM python:3.9
RUN useradd -m -u 1000 user
WORKDIR /code
COPY ./requirements.txt /code/requirements. xt
RUN pip install --upgrade pip
RUN pip install --no-cache-dir --upgrade -r /code/requirements. xt
USER
# The --link flag instructions the Docker to create hard links instead of copying files, Which increases performance and decreases image size.
COPY --link --chown=1000 / code
```

```bash
Docker build --platform=linux/amd64 -t local-lm:v1.
```

```bash
docker run -it -p 7860:7860 --platform=linux/amd64 -e HUGING_FACE_HUB_TOKEN="YOUR_VALUE_HERE" local-lm:v1 python app.py
```
