# logrotate configuration

[logrotate配置地址](https://github.com/183461750/doc-record/blob/main/docs/lang/java/systemctl%E7%AE%A1%E7%90%86Java%E8%BF%9B%E7%A8%8B/logrotate%20%E9%85%8D%E7%BD%AE/support-service)

## Recommendation point 4 above for how to use the production level lottery configuration (AI replies)

The production level `logote` for JavaScript application logs can be configured to automatically rotate, compresse, expire, and avoid excessive use of disk space for log files.The following is the full profile for your `support-service` app：

### 1. Create logote profile

在`/etc/logrotate.d/`目录下创建服务专属配置文件（以服务名命名，便于维护）：

```bash
sudo vim /etc/logrotate.d/support-service
```

### Production level configuration

Add the following configuration (log under `/var/log/support-service/`)：

### Description of configuration item (core parameter)

| Configuration Item     | Description of roles                                                                                                                  |
| ---------------------- | ------------------------------------------------------------------------------------------------------------------------------------- |
| `daily`                | Automatic rotation logs per day (forward rotation to 100 MB in conjunction with `size` parameters)                 |
| `root 30`              | Keep 30 rotation logs (after which the oldest is automatically deleted to avoid full disk)                         |
| `size 100M`            | Force rotation when a single log file reaches 100 MB (prevent ultra-large log files from being open)               |
| `compress`             | Auto-compression with gzip (compression rate of about 70%, significant space saving)                               |
| `delaycompress`        | Legacy logs for the day are not compressed (easy to view temporarily, compressed the next day)                     |
| `create 0640 www www.` | Create a new log file after rotation, permission is `640`, owner/group is `www.` (consistent with the application) |
| `postrotate`           | Script：executed after rotation sends the `USR1` signal to the Javatar process and notifies the app to switch to the new log file      |

### Key concerns (avoid loss of logs)

- **JavaScript application log switching support**：  
  Most JavaScript frameworks (e.g. Logback and Log4j2) support `USR1` signal triggering log reloading without restarting the app.If the app is not supported, use `copytruncate` (but may lose a small number of logs)：
  ```ini
  # Alternatives to postrotate (for apps that do not support USR1 signals)
  copytruncate # Copy log content to backup files before empty original files (logs may be lost during copy)
  ```

- **Consistence**：  
  `create` is required to match the app running (`www`), otherwise the app may not have permission to write to the new log file.

- **Test configuration validity**：  
  Config to perform the following command tests (no actual rotation, output execution plan only)：
  ```bash
  sudo logo -d /etc/logrotate.d/support-service
  ```
  Trigger a turn manually (for validation)：
  ```bash
  sudo logrotate -f /etc/logrotate.d/support-service
  ```

### Daily maintenance

- Check the `/var/log/support-service/` directory periodically to confirm if the log rotates and compresses.
- Adjust `rotate` (reserved days) and `size` (trigger threshold) based on disk space and logs.
- To archive long term logs, a script can be added to `prerote`, syncing log to object storage (e.g. S3, OSS).

This configuration ensures that logs are complete and that disk space is not used indefinitely and meets the stability requirements of the production environment.
