# git usage records

## git-lfs used

[install](https://packagecloud.io/github/git-lfs/install)
[How to use Git LFS](https://help.aliyun.com/document_detail/206889.html)

```shell
# quick install
curl -s https://packagecloud.io/install/repositories/github/git-lfs/script.deb. h | sudo bash
sudo apt-get install git-lfs
# for LFS
git lfs install
# for example. The file at the end of the igfile suffix is stored using Git LFS and requires a track command to set up tracking：
git lfs track "*. igfile"
# Migrate files from regular submissions to lfs (not required)
git lfs migrate import - include="*. igfile"
# You can untrack a class and clean：
git lfs untrack "*.bigfile"
git rm --cached "*.bigfile"

```
