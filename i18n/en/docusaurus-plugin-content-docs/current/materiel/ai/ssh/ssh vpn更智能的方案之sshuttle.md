# sshuttle

## Smarter Scheme (recommended using sshuttle)

If no precision is required to control TUN equipment, it is recommended to use lightweight SSH VPN tool：

```bash
# Install sshuttle (Python written, no kernel driven)
brew install sshuttle

# Launch VPN(Auto-process routing and tunnel)
sshuttle-r root10.0.1.90 --python $(which python 3) 0.0.0.0.0 / 0
```

Effect：

- All traffic automatically via SSH tunnels
- No need to manually configure a TUN device
- Automatically process routing rules

---

### Comparison of the two options

| Features                     | Native SSH TUN Program                            | sshuttle scheme                          |
| ---------------------------- | ------------------------------------------------- | ---------------------------------------- |
| Configuration Complexity     | High (manually managed device) | Low (one-click start) |
| Cross-platform compatibility | Dependency TUN Driver                             | Put Python Implementation                |
| Traffic Control              | Route needs to be configured manually             | Automatically route all traffic          |
| System permissions required  | Root/sudo required                                | Normal User Permissions                  |
| Apply Scene                  | Require fine control of network layer             | Quickly build full traffic VPN           |

---

### Test connection

For original SSH TUN Scheme：

```bash
# Connect and create tunnel
ssh dev-2023-tunnel

# Verify macOS tunnel
ifconfig utun0
# Should see IP

# Test remote connectivity
ping 10.1.0.2
```

---

### Handling FAQ

1. **`utun0: Network is down` error**
   - Confirm TUN driver installed
   - Check if the `sudo` permission is configured correctly

2. **sshuttle cannot be started**
   - Specify Python3 path：`--python $(which python3)`
   - Ensure remote server allows SSH port forwarding

3. **Some apps do not follow the system route**

   - Forward DNS requests using the `--dns` parameter

   ```bash
   sshuttle -r user@host --dns 0.0.0.0
   ```
