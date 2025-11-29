# curl see whether connection is passable

You can use the curl command to check if the connection is smooth.Below are several methods for checking connections with curl command：

1. Send HTTP request： using curl

   `````bash
   curl-I <URL>
   ````
   this will send a HEAD request to the specified URL and return HTTP response header. If the connection succeeds, you will see the HTTP response status code and other relevant information.

   `````
2. Send TCP connection request： using curl

   `````bash
   curl telnet:/<host>:<port>
   ````
   This will try to establish a TCP connection to the specified host and port. If the connection is successful, you will see the status of "Connected".

   `````
3. Test connection： with a specific port using curl

   `````bash
   curl -v telnet:/<host>:<port>
   ````
   This will show details of the connection process to the specified host and port. If the connection is successful, you will see the status of "Connected".
   `````

Note that these commands are only available for checking if the connection is successfully established, not for actual data transfer.

---

Learn more:

1. [Test TCP connection with curl](https://www.unixtutorial.org/test-tcp-connectivity-with-curl/)
2. [Curl: Using curl to test if a port is open: exit immediately upon connection if STDIN is /dev/null](https://curl.se/mail/archive-2022-04/0027.html)
3. [Monitoring - Health check of web page using curl - Unix & Linux Stack Exchange](https://unix.stackexchange.com/questions/84814/health-check-of-web-page-using-curl)
