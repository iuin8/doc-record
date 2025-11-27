# Systemctl manages unlimited reboot issues for Java processes

```bash
# See the report error log
journalctl -u manage-service.service --since "2025-09-03 00:00:00" | grep "Main process exited" -C 5
```

## AI Related Replies Snippet

Yes, systemd records the status of the service and the cause of the restart. You can view the log below to locate the specific cause of the triggering restart：

1. **View service details (recommended)**：
   ```bash
   journalctl -u support-service -f
   ```
   - `-u support-service`：specifies the log to view the `support-service` service
   - `-f`：Track the latest log in real time (omitted for real-time monitoring)

2. **View service restart history and status**：
   ```bash
   systemctl status support-service
   ```
   This command displays information about the current state of the service, the latest reboot time, exit code, e.g.：
   ```
   • Support-service.service - support-service
     Loaded: loaded (/etc/systemd/system/support-service. ervice; enabled; vendor preset: disabled)
     Active: active (running) since Wed 2025-09-03 10:00:00 CST; 5min ago
    Process: 12345 ExecStart=/usr/bin/java. (code=exit, status=143)
   Main PID: 67890 (java)
     CGroup: /system. lice/support-service.service
             — 67890/usr/bin/java -jar...
   ```
   where `code=exited, status=143` denotes the last exit status code (143 usually goes to SIGERM signals).

3. **View earlier logs**：
   ```bash
   journalctl -u support-service --since "2025-09-03 09:00:00" --until "2025-09-03 10:00:00"
   ```
   Filter logs for specified periods of time by time range.

**Key log read**：

- If `Main process exit, code=exit, status=1/FAILURE`, indicates that the application itself exits (non-zero status code), triggers the `Restart=on-failure` configuration.
- If `Killed process 12345 (Java) total-vm:2048M, ...`, it may be because memory exceeds the `MemoryLimit=1024M` restriction to be killed by the system.
- If `Stopped support-service.` occurs after `Stopped support-service.`, indicate that the service is restarted after active cessation (this may be a manual action or other process triggers).

In combination with the application's own log (usually in `/data/xxx/support-service`), reboot causes can be more comprehensively positioned (e.g. OM error, uncaptured exception etc.).
