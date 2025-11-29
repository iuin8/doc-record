# How java hprof files are exported.

In Java, the `hprof` file can be exported in several ways：

**Use the `jmap` command**：

```bash
jmap -dump:form=b,file=your_dump_file.hprof <pid>
```

`<pid>` is the ID of the Java process to analyse.

For example, if process ID is 12345, command is：

```bash
jmap -dump:form=b,file=your_dump_file.hprof 12345
```

**Add parameters when Java app starts**：
can add parameters like `-XX:+HeapDumpOnOutOfMemoryError -XX:HeapDumPath=/to/dump. prof` when launching Java app. The `hprofile` file is automatically generated to the specified path when an memory fill error occurs.

**Connect to the running Java process via Console Tool**：
with export dump features in the Memory table.

It is important to note that the exported `hprof` file may be large and that analysing the `hprof` file requires specific tools, Such as \`\`Eclipse Memory Analyzer\\`.
