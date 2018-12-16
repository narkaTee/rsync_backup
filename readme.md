# Setup
Requires that the user running the backup script has ssh access to the target system.

# Behaviour
Tries to get a daily backup of all the hosts via rsync. If a host is not online 24/7 the script could be run in intervals of x minutes.

# Config file

user is optional, and default to root

`backups.yaml` format:

```yaml
my.host.tld:
  user: non-root
  paths:
    - /etc/
```
