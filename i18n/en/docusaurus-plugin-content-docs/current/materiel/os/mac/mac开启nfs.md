# mac on nfs

Enable NFS service on Mac, can follow the following steps for：

1. **Edit NFS profile**：Open Terminal, enter `sudo vim /etc/exports` command to edit NFS profile. d directories to shared and associated configurations such as `/Users/xx/Documents -alldirs-maproot=root:wheel -network 192. 68.31.0 - mask 255.255.255.0` where `/Users/xxx/Documents` is a directory of the Macs that you want to share, `-network 192. 68.31.0` specializations a network range of allowed access.
2. **Check config file**：after adding content, save and exit the editor.en enter the `sudo nfsdleckexports` order, check that the NFS configuration is correct.
3. **Enable NFS service**：first disable NFS service, enter `sudo nfsddisable` command; then enable NFS service, enter `sudo nfsdenable` command; and finally restart NFS service, enter `sudo nfsdstop` and `sudo nfsdstart` commands.
4. **Check NFS service status**：Enter the `sudo nfsdsdstatus` command to ensure NFS service is running.
5. **Check the NFS shared directory**：uses the `showmount-e` command to see if the shared directory is properly configured. f The commands returns the shared directory list, indicating that the NFS service has been successfully configured.
