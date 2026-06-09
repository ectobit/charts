# adminer

Adminer Helm chart for Kubernetes

![Version: 0.2.0](https://img.shields.io/badge/Version-0.2.0-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 5.4.2](https://img.shields.io/badge/AppVersion-5.4.2-informational?style=flat-square)
[![adminer](https://github.com/ectobit/charts/actions/workflows/adminer.yml/badge.svg)](https://github.com/ectobit/charts/actions/workflows/adminer.yml)
[![License](https://img.shields.io/badge/license-BSD--2--Clause--Patent-orange.svg)](https://github.com/ectobit/charts/blob/main/adminer/LICENSE)

## Add repository

`helm repo add ectobit https://charts.ectobit.com`

## Install

```sh
helm install adminer ectobit/adminer
```

## Helmfile

```yaml
releases:
  - name: adminer
    chart: ectobit/adminer
    namespace: default
    values:
      - ingress:
          enabled: true
          annotations:
            kubernetes.io/ingress.class: nginx
          hosts:
            - host: adminer.your-domain.com
              paths:
                - path: /
                  pathType: Prefix
          tls:
            - secretName: your-domain-com-tls
              hosts:
                - adminer.your-domain.com
```

## MySQL TLS

Set `mysqlTls.enabled=true` and `mysqlTls.secretName` to mount a CA Secret and
load Adminer's `login-ssl` plugin with the required constructor configuration.
Do not set `ADMINER_PLUGINS=login-ssl`; Adminer's stock plugin loader cannot
instantiate plugins that require constructor parameters.

```yaml
env:
  ADMINER_DEFAULT_SERVER: mysql
mysqlTls:
  enabled: true
  secretName: mysql-ca
```

**Homepage:** <https://github.com/ectobit/charts>

## Source Code

- <https://github.com/ectobit/charts/tree/main/adminer>
- <https://github.com/TimWolla/docker-adminer>
- <https://github.com/vrana/adminer>

## Values

| Key                                        | Type   | Default                                                                                | Description                                                                        |
| ------------------------------------------ | ------ | -------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------- |
| affinity                                   | object | `{}`                                                                                   |                                                                                    |
| autoscaling.enabled                        | bool   | `false`                                                                                |                                                                                    |
| autoscaling.maxReplicas                    | int    | `100`                                                                                  |                                                                                    |
| autoscaling.minReplicas                    | int    | `1`                                                                                    |                                                                                    |
| autoscaling.targetCPUUtilizationPercentage | int    | `80`                                                                                   |                                                                                    |
| env                                        | object | `{}`                                                                                   |                                                                                    |
| fullnameOverride                           | string | `""`                                                                                   |                                                                                    |
| image.pullPolicy                           | string | `"IfNotPresent"`                                                                       |                                                                                    |
| image.repository                           | string | `"adminer"`                                                                            |                                                                                    |
| image.tag                                  | string | `""`                                                                                   |                                                                                    |
| imagePullSecrets                           | list   | `[]`                                                                                   |                                                                                    |
| ingress.annotations                        | object | `{}`                                                                                   |                                                                                    |
| ingress.className                          | string | `""`                                                                                   |                                                                                    |
| ingress.enabled                            | bool   | `false`                                                                                |                                                                                    |
| ingress.hosts[0].host                      | string | `"chart-example.local"`                                                                |                                                                                    |
| ingress.hosts[0].paths[0].path             | string | `"/"`                                                                                  |                                                                                    |
| ingress.hosts[0].paths[0].pathType         | string | `"ImplementationSpecific"`                                                             |                                                                                    |
| ingress.tls                                | list   | `[]`                                                                                   |                                                                                    |
| mysqlTls                                   | object | `{"caFilename":"ca.crt","enabled":false,"mountPath":"/etc/mysql-tls","secretName":""}` | Configure Adminer's login-ssl plugin for MySQL servers that require TLS.           |
| mysqlTls.caFilename                        | string | `"ca.crt"`                                                                             | Filename of the CA certificate inside the mounted Secret.                          |
| mysqlTls.enabled                           | bool   | `false`                                                                                | Enable mounting the MySQL CA Secret and loading the configured login-ssl plugin.   |
| mysqlTls.mountPath                         | string | `"/etc/mysql-tls"`                                                                     | Path where the MySQL TLS Secret is mounted in the Adminer container.               |
| mysqlTls.secretName                        | string | `""`                                                                                   | Name of the Secret containing the CA file. Required when mysqlTls.enabled is true. |
| nameOverride                               | string | `""`                                                                                   |                                                                                    |
| nodeSelector                               | object | `{}`                                                                                   |                                                                                    |
| podAnnotations                             | object | `{}`                                                                                   |                                                                                    |
| podSecurityContext                         | object | `{}`                                                                                   |                                                                                    |
| replicaCount                               | int    | `1`                                                                                    |                                                                                    |
| resources                                  | object | `{}`                                                                                   |                                                                                    |
| securityContext                            | object | `{}`                                                                                   |                                                                                    |
| service.port                               | int    | `80`                                                                                   |                                                                                    |
| service.type                               | string | `"ClusterIP"`                                                                          |                                                                                    |
| serviceAccount.annotations                 | object | `{}`                                                                                   |                                                                                    |
| serviceAccount.create                      | bool   | `true`                                                                                 |                                                                                    |
| serviceAccount.name                        | string | `""`                                                                                   |                                                                                    |
| tolerations                                | list   | `[]`                                                                                   |                                                                                    |
