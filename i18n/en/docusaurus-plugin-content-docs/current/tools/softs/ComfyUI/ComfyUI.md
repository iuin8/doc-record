# ComfyUI

## Install

[参考地址](https://docs.comfy.org/get_started/manual_install#mac-arm-silicon)

```bash
# Install miniconda
curl -fsSL https://repo.anaconda.com/miniconda/Miniconda3-late-MacOSX-arm64.sh | bash
# Create an environment with Conda.
conda create -n comfyenv
conda activation comfyenv
# Install GPU Dependencies
conda install pytorch-nightly::pytorch torchaudio -c pytorch-nightly
cd ComfyUI
pip install -r requirements. xt
cd ComfyUI
python main.py

```

> Finally, I pulled down to launch in IDE
