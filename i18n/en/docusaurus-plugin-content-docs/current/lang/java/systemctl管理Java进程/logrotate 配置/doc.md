# Logot configuration

[logrotate配置地址](https://github.com/183461750/doc-record/blob/main/docs/lang/java/systemctl%E7%AE%A1%E7%90%86Java%E8%BF%9B%E7%A8%8B/logrotate%20%E9%85%8D%E7%BD%AE/support-service)

## Recommendation point 4 above for how to use the production level lottery configuration (AI replies)

The production level `logote` for JavaScript application logs can be configured, compresse, expire, and avoid excessive use of disk space for log files. He following is the full profile for your `support-service` app：

### 1. Create logo profile

在`/etc/logrotate.d/`目录下创建服务专属配置文件（以服务名命名，便于维护）：

```bash
sudo vim /etc/logrotate.d/support-service
```

### Production level

Add the following configuration (log under `/var/log/support-service/`)：

### Description of configuration item (core parameter)

| Configuration Item     | Description of roles                                                                                                                  |
| ---------------------- | ------------------------------------------------------------------------------------------------------------------------------------- |
| `daily`                | Automatic translation logs per day (forward route to 100 MB in connection with `size` parameters)                  |
| `root 30`              | Keep 30 adaptation logs (after which the old is automatically deleted to avoid full disk)                          |
| `size 100M`            | Force conversion when a single log file reaches 100 MB (pre-default ultra-large log files from being open)         |
| `compress`             | Auto-compression with gzip (compression rate of about 70%, significant space saving)                               |
| `delaycompress`        | Legacy logs for the day are not compressed (easy to view temporary, compressed the next day)                       |
| `create 0640 www www.` | Create a new log file after rotation, permission is `640`, owner/group is `www.` (consistent with the application) |
| `postrotate`           | Script：executed after adaptation concerns the `USR1` sign to the Javatar process and notifies the app to witness to the new log file  |

### Key concerns (Avoid loss of logs)

- **JavaScript application log witnesses support**：  
  Most JavaScript frames (e.g. Logback and Log4j2) support the `USR1` sign rigging log loading without restoring the app. f The app is not supported, use `copytruncate` (but may lose a small number of logs)：
  ```ini
  # Alternatives to post (for apps that do not support USR1 signatures)
  copytruncate # log content to backup files before empty original files (logs may be lost during copy)
  ```

- **Consuce**：  
  `create` is required to match the app running (\`www.), Otherwise the app may not have permission to write to the new log file.

- **Test configuration validity**：  
  Config to perform the following commands (no actual rotation, output execution plan only)：
  ```bash
  sudo logo -d /etc/logrotate.d/support-service
  ```
  Trigger a turnly (for validation)：
  ```bash
  sudo logrotate -f /etc/logrotate.d/support-service
  ```

### Daily maintenance

- Check the `/var/log/support-service/` directory over time to confirm if the log roots and compresses.
- Adjust `rotate` (reserved days) and `size` (rigger them) based on disk space and logs.
- To archive long term logs, a script can be added to `prerote`, syncing log to object store (e.g. S3, OSS).

This configuration increases that logs are complete and that disk space is not used to quantify and measure the stability requirements of the production environment.
