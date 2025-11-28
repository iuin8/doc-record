# systemctl manages Java processes

[support-service.service文件地址](https://github.com/183461750/doc-record/blob/main/docs/lang/java/systemctl%E7%AE%A1%E7%90%86Java%E8%BF%9B%E7%A8%8B/support-service.service)

[相关OOM问题分析](https://github.com/183461750/doc-record/blob/main/materiel/ai/java/systemctl%E7%AE%A1%E7%90%86Java%E8%BF%9B%E7%A8%8B%E6%97%A0%E9%99%90%E9%87%8D%E5%90%AF%E9%97%AE%E9%A2%98.md)

## Help provide a better production level JavaScript app systemctl configuration (provided by AI) in combination with previous systctl configuration for your systemctl and subsequent OOM questions

Below is an optimized production level system for Java applications, with a focus on OOM issues, greater stability and observability, and following the production environment best practices：

### Key Optimization Description (for OOM and production stability)：

1. **OM Issues**
   - Automatically generate dump files when new `HeapDumpOnOutOfMemoryError` and `HeapDumpPath`：OOOM to analyze memory leaks afterwards
   - Add `ExitOnOutOfMemoryError` to exit on：OOOM, avoiding zombie process
   - Detach `MemoryHigh` and `Memory Limit`：systems will be recycled at their own initiative when the memory is close to `MemoryHigh`. More than `MemoryLimit` will kill OM
   - It is recommended that `Xmx` be set to `Memory Limit`, e.g. `Memory Limit=2G`, corresponding to `Xmx=160M`), reserved system memory

2. **Enhanced Stability**
   - Add Restart Frequency Limit (`StartLimitInterval`+`StartLimitBurst`)：prevents an unlimited reboot after OOM that will cause the system to exhaust
   - Integrate dependencies into：explicitly rely on networks, logs, and database services
   - Add `ExecRelad`：to smooth reload configuration, reduce reboot
   - Extend timeout in：to ensure that there is enough time to start and stop in complex scenarios

3. **Observability Update**
   - Individual log file path：for log aggregation and analysis
   - Generate PID file：for easy monitoring system identification process
   - Record core dump：for depth troubleshooting
   - Unified log logo：will allow service logs to be filtered from journal.

4. **Security**
   - Enable directory isolation and permissions control：less attack face
   - Limit process permission to：prevent permission to increase risk

### Use suggestion：

1. Execute the `systemctl daemon-load` reload configuration after first deployment
2. Periodically check dump files and logs in `/var/log/support-service` directory
3. Adjust `MemoryLimit`, `Xms` and `Xmx` based on the actual memory usage of the app (for example by monitoring tools such as Prometheus+Grafana)
4. Configure log rotation with `logrote` to avoid logging files being too large

These optimization will effectively reduce the disruption of services caused by OOM and provide adequate diagnostic information when problems arise, while enhancing the stability and security of services in the production environment.
