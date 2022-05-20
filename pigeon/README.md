# pigeon

A Helm chart for Kubernetes

![Version: 0.1.0](https://img.shields.io/badge/Version-0.1.0-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: edge](https://img.shields.io/badge/AppVersion-edge-informational?style=flat-square)
[![pigeon](https://github.com/ectobit/charts/actions/workflows/pigeon.yml/badge.svg)](https://github.com/ectobit/charts/actions/workflows/pigeon.yml)
[![License](https://img.shields.io/badge/license-BSD--2--Clause--Patent-orange.svg)](https://github.com/ectobit/charts/blob/main/pigeon/LICENSE)

## Add repository

`helm repo add ectobit https://charts.ectobit.com`

## Install

```sh
helm install pigeon ectobit/pigeon
```

## Helmfile

```yaml
releases:
  - name: pigeon
    chart: ectobit/pigeon
    namespace: default
    values:
      - ingress:
          enabled: true
          annotations:
            kubernetes.io/ingress.class: nginx
          hosts:
            - host: pigeon.your-domain.com
              paths:
                - path: /
                  pathType: Prefix
          tls:
            - secretName: your-domain-com-tls
              hosts:
                - pigeon.your-domain.com
```

## Values

| Key                                        | Type   | Default                    | Description |
| ------------------------------------------ | ------ | -------------------------- | ----------- |
| affinity                                   | object | `{}`                       |             |
| autoscaling.enabled                        | bool   | `false`                    |             |
| autoscaling.maxReplicas                    | int    | `100`                      |             |
| autoscaling.minReplicas                    | int    | `1`                        |             |
| autoscaling.targetCPUUtilizationPercentage | int    | `80`                       |             |
| fullnameOverride                           | string | `""`                       |             |
| image.pullPolicy                           | string | `"IfNotPresent"`           |             |
| image.repository                           | string | `"quay.io/ectobit/pigeon"` |             |
| image.tag                                  | string | `""`                       |             |
| imagePullSecrets                           | list   | `[]`                       |             |
| ingress.annotations                        | object | `{}`                       |             |
| ingress.enabled                            | bool   | `false`                    |             |
| ingress.hosts[0].host                      | string | `"chart-example.local"`    |             |
| ingress.hosts[0].paths                     | list   | `[]`                       |             |
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
