# Hawk event database specification

## Getting started

### Docker way

- Move `.env.sample` to `.env` and edit it
- Run `docker-compose up`
- Create users (see below)

### Without docker

- Install MongoDB
- Edit `/etc/mongod.conf` [to listen on all addresses](https://docs.mongodb.com/manual/reference/configuration-options/#net.bindIpAll) if necessary
- Create users (see below)
- Edit `/etc/mongod.conf` [to enable authentication](https://docs.mongodb.com/manual/reference/configuration-options/#security.authorization)

### Creating users and databases

You can use script `bin/generate_user.sh` to create specified user with random password

```
Usage:
  ./bin/generate_user.sh user [-d]

Options:
  -d  Use docker-compose (Requires CID in .env or as env variable)

Env vars:
  MONGO_INITDB_ROOT_USERNAME    root username
  MONGO_INITDB_ROOT_PASSWORD    root password
```

Needed users:

- hawk
- hawk-dev (for development)

## Schema

| Collection | Schema file                              |
| ---------- | ---------------------------------------- |
| events     | [`event.schema.json`](event.schema.json) |

## Hardening MongoDB (non-docker)

To block all connections except from some ips:

- Write allowed ips to `ALLOWED_IPS=` variable delimited by whitespace in `bin/block_mongo.sh`
- Run `bin/block_mongo.sh`
- Optionally: save iptables rules

  Install `iptables-save` and `iptables-persistent`

  Run `iptables-save > /etc/iptables/rules.v4` for ipv4 addresses

  Run `ip6tables-save > /etc/iptables/rules.v6` for ipv6 addresses

> Change `iptables` to `ip6tables` in `bin/block_mongo.sh` to block ipv6 addresses
