# lsyncd-docker

### Config example

```
services:
  app:
    image: exithub/lsyncd-docker:latest
    environment:
      - EXCLUDE_PATTERN="thumbs/*,*.tmp"
    volumes:
      - /data/lsyncd_test/source1:/source
      - /data/lsyncd_test/output1:/destination
```