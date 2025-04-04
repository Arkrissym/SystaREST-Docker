# Docker container with SystaREST from [SystaPI](https://github.com/beep-projects/SystaPi)

### DNS
You need to setup your local dns-server to resolve "paradigma.remoteportal.de" to your docker host.

### SystaREST

Example docker-compose.yml
``` yml
services:
  systa-rest:
    image: ghcr.io/arkrissym/systarest-docker:main
    restart: always
    ports:
      - 22460:22460/udp
      - 1337:1337/tcp
```
