# vanity

A Helm chart for Kubernetes

![Version: 0.2.4](https://img.shields.io/badge/Version-0.2.4-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: latest](https://img.shields.io/badge/AppVersion-latest-informational?style=flat-square) ![chart](https://github.com/ectobit/vanity/workflows/chart/badge.svg)

## Prerequisites

`helm plugin install https://github.com/aslafy-z/helm-git`

## Add repository

`helm repo add vanity "git+https://github.com/ectobit/vanity@deploy/charts?ref=main"`

## Install

```sh
helm install vanity vanity/vanity \
  --set config.domain=your-domain.com \
  --set config.packages.your_package=https://github.com/your_account/your_repo
```

## Helmfile

```yaml
releases:
  - name: vanity
    chart: vanity/vanity
    namespace: default
    values:
      - config:
          domain: your-domain.com
          packages:
            your_package: https://github.com/your_account/your_repo
      - ingress:
          enabled: true
          annotations:
            kubernetes.io/ingress.class: nginx
          hosts:
            - host: your-domain.com
              paths: ['/']
          tls:
            - secretName: your-domain-com-tls
              hosts:
                - your-domain.com
```

## Values

| Key                                        | Type   | Default                    | Description |
| ------------------------------------------ | ------ | -------------------------- | ----------- |
| affinity                                   | object | `{}`                       |             |
| autoscaling.enabled                        | bool   | `false`                    |             |
| autoscaling.maxReplicas                    | int    | `100`                      |             |
| autoscaling.minReplicas                    | int    | `1`                        |             |
| autoscaling.targetCPUUtilizationPercentage | int    | `80`                       |             |
| config.domain                              | string | `"go.your-domain.com"`     |             |
| config.packages                            | object | `{}`                       |             |
| fullnameOverride                           | string | `""`                       |             |
| image.pullPolicy                           | string | `"IfNotPresent"`           |             |
| image.repository                           | string | `"quay.io/ectobit/vanity"` |             |
| image.tag                                  | string | `""`                       |             |
| imagePullSecrets                           | list   | `[]`                       |             |
| ingress.annotations                        | object | `{}`                       |             |
| ingress.enabled                            | bool   | `false`                    |             |
| ingress.hosts[0].host                      | string | `"chart-example.local"`    |             |
| ingress.hosts[0].paths                     | list   | `[]`                       |             |
| ingress.tls                                | list   | `[]`                       |             |
| logLevel                                   | string | `"info"`                   |             |
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
