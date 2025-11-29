# openLLM

[GitHub地址](https://github.com/bentoml/OpenLLM)

## Install

```bash
# or pip3 install openlm
pip install openlm
openlm hello

```

- Chat Interface

OpenLLM provides a chat UI at the /chat endpoint for the launched LLM server at http://localhost:3000/chat.

- Use

```bash
openlm serve llama3.2:1b

openlm un llama3:8b
openlm model list
openllm repo update
openlm model get llama3.2:1b
```

- Add Model

[GitHub地址](https://github.com/bentoml/openllm-models)

```bash
openlm repo add <repo-name> <repo-url>
openlm repo add nightly https://github.com/bentoml/openllm-models@nigly
```

- test

```bash
export VLLM_DEVICE=cpu
openlm serve gemma2:2b
```
