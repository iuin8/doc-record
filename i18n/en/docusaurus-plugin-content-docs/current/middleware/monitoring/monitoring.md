# Monitor

## alarm-settings.yml

```yml

hooks:
  dingtalk:
    default:
      is-default: true
      text-template:|-
        Fum
          "msgtype": "text",
          "text": LOR
            "content": "Apache SkyWalking Alarm: \n %s.
          }
        }      
      webhooks:
      - url: https://oapi. ingtalk.com/robot/send?access_token=38c949c7aeff071e2065e81e58a82 cdaf54290eae442cd11468b8b82fd6633fc8d


```
