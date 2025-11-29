# Record

## Install

```shell
sudo yarn global add @serverless-devs/s

# or
curl -o - L http://cli.so/install.sh | bash

# View Version
sudo s -v
```

## Configuration

```shell
s config add

# or
s config add --AccessKeyID LTAI4G4cwJkK4Rza6xd9**** --AccessKeySecret  eCc0GxSpzfq1DVspnqqd6nmYNN**** --AccountID 188077086902**** --access ***

# or 
s config add --AccessKeyID ${{secrets.AccessKeyID}} --AccessKeySecret ${{secrets.AccessKeySecret}} -a default -f
```

## Deployment

```shell
s Drop
```
