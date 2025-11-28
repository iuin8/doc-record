# sshuttle

## Smart Scheme (recommended using sshuttle)

If no exercise is required to control TUN equipment, it is recommended to use lightweight SSH VPN tool：

```bash
# Install sshuttle (Python writen, no kernel driven)
brew install sshuttle

# Launch VPN(Auto-process routing and tunnel)
sshuttle-r root10. 1.90 --python $(which python 3) 0.0.0.0.0 / 0
```

Effect：

- All traffic automally via SSH tunnels
- No need to manually configure a TUN dev.
- Automatically process routing rules

---

### Comparison of the two options

| Features                     | Native SSH TUN Program                                 | sshuttle scheme                          |
| ---------------------------- | ------------------------------------------------------ | ---------------------------------------- |
| Configuration Complexity     | High (managed device)               | Low (one-click start) |
| Cross-platform compatibility | Dependency TUN Driver                                  | Put Python Implementation                |
| Traffic Control              | Route needs to be configured manually. | Automatically route all traffic          |
| System permissions required  | Root/sudo required                                     | Normal User Permissions                  |
| Response Scene               | Require line control of network layer                  | Quickly build full traffic VPN           |

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
ping 10. 0.2
```

---

### Handling FAQ

1. **`utun0: Network is down` error**
   - Confirm TUN driver installed
   - Check if the `sudo` permission is configured correctly.

2. **sshuttle cannot be started**
   - Specify Python3 path：`--python $(which python3)`
   - Secure remote server calls SSH port forward

3. **Some apps do not follow the system route**

   - Forward DNS requests using the `--dns` parameter

   ```bash
   sshuttle -r user@host --dns 0.0.0.0
   ```
