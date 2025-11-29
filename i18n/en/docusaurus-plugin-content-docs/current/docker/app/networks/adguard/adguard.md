## DoH and DoT configuration

- Apply for a free certificate using Lett’s Encrypt
- A domain name for abc.com is registered, please go to DNS administration first to add a new A record
- Install certbot

```shell
# Demonstrate root
$ sudo su
# First Update system
$ apt update && apt full-upgrade -y
# Install certbot
$ apt install certbot
# Start sign with email domain name consigned to your own
$ certbot --standalone-n --agree-tos --email webmaster@abc. om --preference-challenges HTML -d dns.abc.com
```

- Certificates automatic regeneration

```shell
# 先測試看看自動更新證書有無問題，下面這一條指令會測試去更新，並不會實際去更新
$ certbot renew --dry-run
# 如無問題的話，接著我們要把兩個月簽名一次的工作加入排程
$ crontab -e

# 選擇 nano 文字編輯器，打開文件後，複製以下到裡面，然後保存退出
0 0 15 */2 * /usr/bin/certbot renew --quiet
# 如此每隔兩個月十五號他就會自動執行一次續簽證書


```

- Use DNS Cloak setting on demand auto-witch on iOS

  [参考文章](https://www.jkg.tw/p2660/)

## Blocklist

- https://easylist-downloads.adblockplus.org/easylistchina.txt
- https://anti-ad.net/easylist.txt
- [参考文章](https://www.isharepc.com/27230.html)

## DNS Server

```text
223.5.5.5
119.29.29
114.114.114.114
223.6.6
2400:3200:1
2400:3200:baba:1
https://dns.alids.com/dns-query
tls://dns.alids.idns.com
```
