# vanity

Go vanity imports HTTP server Helm chart for Kubernetes

![Version: 0.3.9](https://img.shields.io/badge/Version-0.3.9-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 0.3.8](https://img.shields.io/badge/AppVersion-0.3.8-informational?style=flat-square) [![vanity](https://github.com/ectobit/charts/actions/workflows/vanity.yml/badge.svg)](https://github.com/ectobit/charts/actions/workflows/vanity.yml)

## Add repository

`helm repo add ectobit https://charts.ectobit.com`

## Install

```sh
helm install vanity ectobit/vanity \
  --set config.domain=your-domain.com \
  --set config.packages.your_package=https://github.com/your_account/your_repo
```

## Helmfile

```yaml
releases:
  - name: vanity
    chart: ectobit/vanity
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
              paths: ["/"]
          tls:
            - secretName: your-domain-com-tls
              hosts:
                - your-domain.com
```

**Homepage:** <https://github.com/ectobit/charts>

## Source Code

- <https://github.com/ectobit/vanity>

## Values

| Key                                        | Type   | Default                                       | Description                                                                    |
| ------------------------------------------ | ------ | --------------------------------------------- | ------------------------------------------------------------------------------ |
| affinity                                   | object | `{}`                                          |                                                                                |
| autoscaling.enabled                        | bool   | `false`                                       |                                                                                |
| autoscaling.maxReplicas                    | int    | `100`                                         |                                                                                |
| autoscaling.minReplicas                    | int    | `1`                                           |                                                                                |
| autoscaling.targetCPUUtilizationPercentage | int    | `80`                                          |                                                                                |
| config.domain                              | string | `"go.your-domain.com"`                        |                                                                                |
| config.packages                            | object | `{}`                                          |                                                                                |
| fullnameOverride                           | string | `""`                                          |                                                                                |
| image.pullPolicy                           | string | `"IfNotPresent"`                              |                                                                                |
| image.repository                           | string | `"ectobit/vanity"`                            |                                                                                |
| image.tag                                  | string | `""`                                          |                                                                                |
| imagePullSecrets                           | list   | `[]`                                          |                                                                                |
| ingress.annotations                        | object | `{}`                                          |                                                                                |
| ingress.enabled                            | bool   | `false`                                       |                                                                                |
| ingress.hosts                              | list   | `[{"host":"chart-example.local","paths":[]}]` | kubernetes.io/tls-acme: "true"                                                 |
| ingress.tls                                | list   | `[]`                                          |                                                                                |
| logLevel                                   | string | `"info"`                                      |                                                                                |
| nameOverride                               | string | `""`                                          |                                                                                |
| nodeSelector                               | object | `{}`                                          |                                                                                |
| podAnnotations                             | object | `{}`                                          |                                                                                |
| podSecurityContext                         | object | `{}`                                          |                                                                                |
| replicaCount                               | int    | `1`                                           |                                                                                |
| resources                                  | object | `{}`                                          |                                                                                |
| securityContext                            | object | `{}`                                          |                                                                                |
| service.port                               | int    | `80`                                          |                                                                                |
| service.type                               | string | `"ClusterIP"`                                 |                                                                                |
| serviceAccount.annotations                 | object | `{}`                                          |                                                                                |
| serviceAccount.create                      | bool   | `true`                                        |                                                                                |
| serviceAccount.name                        | string | `""`                                          | If not set and create is true, a name is generated using the fullname template |
| tolerations                                | list   | `[]`                                          |                                                                                |
