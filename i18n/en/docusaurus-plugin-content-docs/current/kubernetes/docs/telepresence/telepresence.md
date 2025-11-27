# Teleknowledge Usage

## Telepresence Quick Start

[Teleprest Quick Start](https://www.getambassador.io/docs/telepresence/latest/quick-start?os=macos)

## kubectl connects cluster via kubeconconfig.

```shell
# Set cluster
kubectl config set-cluster ocms-dsu --kubeconfig ~/dev/projects/IdeaProjects/company/iuin/mall/outsource-deemploy/snow/ocms-dsu.yaml
kubectl config set-context ocms-dsu --kubeconfig ~/dev/projects/IdeaProjects/company/iuin/mall/outsource-employ/snow/ocms-dsu.yaml
# View current cluster
kubtl config current-context

```

## Related questions

`git clone https://github.com/ambassadorlabs/telepresence-local-quickstart.git --recurse-submodules`
\- What is the role of `--recurse-submodules` in this command?
Make sure that all of the submodules it relies on are cloned and set up so that developers can start working directly without manually initializing and updating submodules.
