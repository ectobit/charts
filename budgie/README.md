# budgie

Micro service in Rust to send e-mails using SMTP relay

![Version: 0.1.1](https://img.shields.io/badge/Version-0.1.1-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 0.1.3](https://img.shields.io/badge/AppVersion-0.1.3-informational?style=flat-square)
[![budgie](https://github.com/ectobit/charts/actions/workflows/budgie.yml/badge.svg)](https://github.com/ectobit/charts/actions/workflows/budgie.yml)
[![License](https://img.shields.io/badge/license-BSD--2--Clause--Patent-orange.svg)](https://github.com/ectobit/charts/blob/main/budgie/LICENSE)

## Add repository

`helm repo add ectobit https://charts.ectobit.com`

## Install

```sh
helm install budgie ectobit/budgie
```

**Homepage:** <https://github.com/ectobit/charts>

## Source Code

- <https://github.com/ectobit/budgie>

## Values

| Key                                        | Type   | Default                    | Description |
| ------------------------------------------ | ------ | -------------------------- | ----------- |
| affinity                                   | object | `{}`                       |             |
| autoscaling.enabled                        | bool   | `false`                    |             |
| autoscaling.maxReplicas                    | int    | `100`                      |             |
| autoscaling.minReplicas                    | int    | `1`                        |             |
| autoscaling.targetCPUUtilizationPercentage | int    | `80`                       |             |
| env                                        | list   | `[]`                       |             |
| fullnameOverride                           | string | `""`                       |             |
| image.pullPolicy                           | string | `"IfNotPresent"`           |             |
| image.repository                           | string | `"ectobit/budgie"`         |             |
| image.tag                                  | string | `""`                       |             |
| imagePullSecrets                           | list   | `[]`                       |             |
| ingress.annotations                        | object | `{}`                       |             |
| ingress.className                          | string | `""`                       |             |
| ingress.enabled                            | bool   | `false`                    |             |
| ingress.hosts[0].host                      | string | `"chart-example.local"`    |             |
| ingress.hosts[0].paths[0].path             | string | `"/"`                      |             |
| ingress.hosts[0].paths[0].pathType         | string | `"ImplementationSpecific"` |             |
| ingress.tls                                | list   | `[]`                       |             |
| nameOverride                               | string | `""`                       |             |
| nodeSelector                               | object | `{}`                       |             |
| podAnnotations                             | object | `{}`                       |             |
| podSecurityContext                         | object | `{}`                       |             |
| replicaCount                               | int    | `1`                        |             |
| resources                                  | object | `{}`                       |             |
| securityContext                            | object | `{}`                       |             |
| service.port                               | int    | `80`                       |             |
| service.type                               | string | `"ClusterIP"`              |             |
| serviceAccount.annotations                 | object | `{}`                       |             |
| serviceAccount.create                      | bool   | `true`                     |             |
| serviceAccount.name                        | string | `""`                       |             |
| tolerations                                | list   | `[]`                       |             |
