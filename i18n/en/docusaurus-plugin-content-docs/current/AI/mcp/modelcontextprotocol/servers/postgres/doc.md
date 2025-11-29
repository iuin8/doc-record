# Most usage record

[官方文档](https://github.com/modelcontextprotocol/servers/tree/main/src/postgres)

- Docker Methodod

```bash
{
  "mcpServers": {
    "postgres": {
      "command": "docker",
      "args": [
        "run", 
        "-i", 
        "--rm", 
        "mcp/postgres", 
        "postgresql://host.docker.internal:5432/mydb"]
    }
  }
}
```
