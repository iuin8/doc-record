# How do I use the macos system's sandbox?

使用macOS系统的沙箱环境可以通过以下步骤完成：

1. Create sandbox profile：
   - Open text editor to create a new text file.
   - Write sandbox configuration rules in the file. Specify the resources and permissions that the app can be accessed. or example, you can specify files that the app can read and write to, access to the network, etc.
   - Save the file and name it to sandbox.sb or other names you like.

2. Enable sandbox environment：
   - Open Terminal application.
   - Enable sandbox environment and run application： using the following orders

     ```shell
     sandbox-exec -f /path/to/sandbox.sb/Applications/YourApp.app/Contents/MacOS/YourApp
     ```

     Replace `/path/to/sandbox.sb` with the actual path to save your sandbox configuration file, `/Applications/YourApp.app` to the path of the app you want to run.

3. Test and Debug：
   - Run the app and test its features. Depending on the rules for sandbox configuration files, applications may be subject to some restrictions.
   - If the app does not function properly or has problems, you can check the rules in the sandbox configuration file and just so.

Please note that the use of the sandbox environment requires some understanding and technical knowledge. Ensure that relevant documents are carefully read and properly tested and debugged when creating sandbox configuration files.

---

slug: /materiel/ai/sandbox/macos-sandbox-usage

Learn more:

1. [Configuring the macOS App Sandbox - Apple Developer](https://developer.apple.com/documentation/xcode/configuring-the-macos-app-sandbox)
2. [macOS Sandbox - HackTricks](https://book.hacktricks.xyz/macos-hardening/macos-security-and-privilege-escalation/macos-security-protections/macos-sandbox)
3. [macos - Is there a sandbox program like Sandboxie for Mac? - Ask Different](https://apple.stackexchange.com/questions/258318/is-there-a-sandboxing-program-like-sandboxie-for-mac)
