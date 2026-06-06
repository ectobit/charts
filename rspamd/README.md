# rspamd

Rspamd Helm chart for Kubernetes

![Version: 0.12.0](https://img.shields.io/badge/Version-0.12.0-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 3.14.0-alpine3.23.4](https://img.shields.io/badge/AppVersion-3.14.0--alpine3.23.4-informational?style=flat-square)
[![rspamd](https://github.com/ectobit/charts/actions/workflows/rspamd.yml/badge.svg)](https://github.com/ectobit/charts/actions/workflows/rspamd.yml)
[![License](https://img.shields.io/badge/license-BSD--2--Clause--Patent-orange.svg)](https://github.com/ectobit/charts/blob/main/rspamd/LICENSE)

## Add repository

`helm repo add ectobit https://charts.ectobit.com`

## Install

```sh
helm install rspamd ectobit/rspamd
```

## Helmfile

```yaml
releases:
- name: rspamd
  chart: ectobit/rspamd
  - redis:
      enabled: true
      cluster:
        enabled: false
      serviceAccount:
        create: true
      rbac:
        create: true
      usePassword: false
      master:
        persistence:
          enabled: true
          size: 128Mi
  - persistence:
      enabled: true
      size: 4Mi
```

## Additional configuration (manual)

```sh
rspamadm configwizard
rspamadm dkim_keygen -b 2048 -s 2020 -k /var/lib/rspamd/dkim/2020.key > /var/lib/rspamd/dkim/2020.txt
```

Take care to use the same key name as in values config.dkimSelector.

## DNS resolver configuration

```yaml
config:
  options: |
    dns {
      nameserver = ["185.12.64.1:53", "185.12.64.2:53"];
    }
```

## Controller access

The Rspamd controller worker is rendered localhost-only by default. To allow other pods in the same namespace to run commands such as `rspamc -h rspamd:11334 learn_spam`, bind the controller to the pod network and restrict access with `secureIp` and/or a Kubernetes NetworkPolicy. Keep the Service `ClusterIP`-only and do not expose the controller outside the cluster by default.

```yaml
config:
  workerController:
    bindSocket: "*:11334"
    secureIp:
      - "127.0.0.1"
      - "::1"
      - "10.244.0.0/16"
```

## RBL overrides

Use `config.rbl` to render `/etc/rspamd/local.d/rbl.conf` and disable or override individual RBL rules.

```yaml
config:
  rbl: |
    rbls {
      senderscore_reputation {
        enabled = false;
      }
    }
```

## Redis history configuration

When `redis.enabled=true`, the chart renders `/etc/rspamd/local.d/history_redis.conf` with an upstream-compatible history key prefix by default:

```yaml
config:
  historyRedis:
    keyPrefix: "rs_history{{HOSTNAME}}{{COMPRESS}}"
```

**Homepage:** <https://github.com/ectobit/charts>

## Source Code

- <https://github.com/ectobit/charts/tree/main/rspamd>
- <https://github.com/ectobit/container-images/tree/main/rspamd>

## Requirements

| Repository                         | Name  | Version |
| ---------------------------------- | ----- | ------- |
| https://charts.bitnami.com/bitnami | redis | 25.5.3  |

## Values

| Key                                 | Type   | Default                                                                                                                                                                                                                                                                                                                    | Description                                                                                                          |
| ----------------------------------- | ------ | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------- |
| affinity                            | object | `{}`                                                                                                                                                                                                                                                                                                                       |                                                                                                                      |
| config.blacklist.fromMap            | string | `""`                                                                                                                                                                                                                                                                                                                       |                                                                                                                      |
| config.blacklist.ipMap              | string | `""`                                                                                                                                                                                                                                                                                                                       |                                                                                                                      |
| config.dkimSelector                 | int    | `2020`                                                                                                                                                                                                                                                                                                                     |                                                                                                                      |
| config.historyRedis.compress        | bool   | `true`                                                                                                                                                                                                                                                                                                                     | Enable Redis history compression.                                                                                    |
| config.historyRedis.enabled         | bool   | `true`                                                                                                                                                                                                                                                                                                                     | Render /etc/rspamd/local.d/history_redis.conf when redis.enabled is true.                                            |
| config.historyRedis.extraConfig     | string | `""`                                                                                                                                                                                                                                                                                                                       | Additional raw Rspamd history_redis configuration.                                                                   |
| config.historyRedis.keyPrefix       | string | `"rs_history{{HOSTNAME}}{{COMPRESS}}"`                                                                                                                                                                                                                                                                                     | Redis history key prefix. The default matches Rspamd upstream and expands inside Rspamd.                             |
| config.historyRedis.nrows           | int    | `200`                                                                                                                                                                                                                                                                                                                      | Maximum number of Redis history rows.                                                                                |
| config.historyRedis.subjectPrivacy  | bool   | `false`                                                                                                                                                                                                                                                                                                                    | Enable Redis history subject privacy.                                                                                |
| config.milterHeaders                | string | `"use = [\"x-spamd-bar\", \"x-spam-level\", \"authentication-results\"];\nauthenticated_headers = [\"authentication-results\"];\n"`                                                                                                                                                                                        |                                                                                                                      |
| config.multiMap                     | string | `"WHITELIST_IP {\n  type = \"ip\";\n  map = \"$CONFDIR/local.d/whitelist_ip.map\";\n  description = \"Local ip whitelist\";\n  action = \"accept\";\n}\n\nWHITELIST_FROM {\n  type = \"from\";\n  map = \"$CONFDIR/local.d/whitelist_from.map\";\n  description = \"Local from whitelist\";\n  action = \"accept\";\n}\n"` |                                                                                                                      |
| config.options                      | string | `""`                                                                                                                                                                                                                                                                                                                       | Additional Rspamd options rendered to /etc/rspamd/local.d/options.inc.                                               |
| config.overrideClassifierBayes      | string | `"autolearn = true;\n"`                                                                                                                                                                                                                                                                                                    |                                                                                                                      |
| config.rbl                          | string | `""`                                                                                                                                                                                                                                                                                                                       | Rspamd RBL overrides rendered to /etc/rspamd/local.d/rbl.conf. Use this to disable or override individual RBL rules. |
| config.whitelist.fromMap            | string | `""`                                                                                                                                                                                                                                                                                                                       |                                                                                                                      |
| config.whitelist.ipMap              | string | `""`                                                                                                                                                                                                                                                                                                                       |                                                                                                                      |
| config.workerController.bindSocket  | string | `"localhost:11334"`                                                                                                                                                                                                                                                                                                        | Rspamd controller bind socket. Keep localhost-only unless namespace-local access is required.                        |
| config.workerController.enabled     | bool   | `true`                                                                                                                                                                                                                                                                                                                     | Render /etc/rspamd/local.d/worker-controller.inc.                                                                    |
| config.workerController.extraConfig | string | `""`                                                                                                                                                                                                                                                                                                                       | Additional raw Rspamd controller worker configuration.                                                               |
| config.workerController.password    | string | `""`                                                                                                                                                                                                                                                                                                                       | Optional controller password.                                                                                        |
| config.workerController.secureIp    | list   | `["127.0.0.1","::1"]`                                                                                                                                                                                                                                                                                                      | IPs or CIDR ranges allowed to access the controller.                                                                 |
| fullnameOverride                    | string | `""`                                                                                                                                                                                                                                                                                                                       |                                                                                                                      |
| image.pullPolicy                    | string | `"IfNotPresent"`                                                                                                                                                                                                                                                                                                           |                                                                                                                      |
| image.repository                    | string | `"ectobit/rspamd"`                                                                                                                                                                                                                                                                                                         |                                                                                                                      |
| image.tag                           | string | `""`                                                                                                                                                                                                                                                                                                                       |                                                                                                                      |
| imagePullSecrets                    | list   | `[]`                                                                                                                                                                                                                                                                                                                       |                                                                                                                      |
| nameOverride                        | string | `""`                                                                                                                                                                                                                                                                                                                       |                                                                                                                      |
| nodeSelector                        | object | `{}`                                                                                                                                                                                                                                                                                                                       |                                                                                                                      |
| persistence.accessMode              | string | `"ReadWriteOnce"`                                                                                                                                                                                                                                                                                                          |                                                                                                                      |
| persistence.annotations             | object | `{}`                                                                                                                                                                                                                                                                                                                       |                                                                                                                      |
| persistence.enabled                 | bool   | `false`                                                                                                                                                                                                                                                                                                                    |                                                                                                                      |
| persistence.size                    | string | `"128Mi"`                                                                                                                                                                                                                                                                                                                  |                                                                                                                      |
| podAnnotations                      | object | `{}`                                                                                                                                                                                                                                                                                                                       |                                                                                                                      |
| podSecurityContext.fsGroup          | int    | `101`                                                                                                                                                                                                                                                                                                                      |                                                                                                                      |
| redis.enabled                       | bool   | `false`                                                                                                                                                                                                                                                                                                                    |                                                                                                                      |
| replicaCount                        | int    | `1`                                                                                                                                                                                                                                                                                                                        |                                                                                                                      |
| resources                           | object | `{}`                                                                                                                                                                                                                                                                                                                       |                                                                                                                      |
| securityContext                     | object | `{}`                                                                                                                                                                                                                                                                                                                       |                                                                                                                      |
| service.controllerPort              | int    | `11334`                                                                                                                                                                                                                                                                                                                    |                                                                                                                      |
| service.port                        | int    | `11333`                                                                                                                                                                                                                                                                                                                    |                                                                                                                      |
| service.proxyPort                   | int    | `11332`                                                                                                                                                                                                                                                                                                                    |                                                                                                                      |
| service.type                        | string | `"ClusterIP"`                                                                                                                                                                                                                                                                                                              |                                                                                                                      |
| serviceAccount.annotations          | object | `{}`                                                                                                                                                                                                                                                                                                                       |                                                                                                                      |
| serviceAccount.create               | bool   | `true`                                                                                                                                                                                                                                                                                                                     |                                                                                                                      |
| serviceAccount.name                 | string | `""`                                                                                                                                                                                                                                                                                                                       |                                                                                                                      |
| tolerations                         | list   | `[]`                                                                                                                                                                                                                                                                                                                       |                                                                                                                      |

## To do

- check alternative way for health check

```sh
curl -f -L http://localhost:11334/ || exit 1
```

## References

- [Mailserver mit Dovecot, Postfix, MySQL und Rspamd unter Debian 10 Buster](https://thomas-leister.de/mailserver-debian-buster/) by Thomas Leister
