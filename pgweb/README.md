# pgweb

pgweb Helm chart for Kubernetes

![Version: 0.1.0](https://img.shields.io/badge/Version-0.1.0-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 0.11.10](https://img.shields.io/badge/AppVersion-0.11.10-informational?style=flat-square) [![pgweb](https://github.com/ectobit/charts/actions/workflows/pgweb.yml/badge.svg)](https://github.com/ectobit/charts/actions/workflows/pgweb.yml)

## Add repository

`helm repo add ectobit https://charts.ectobit.com`

## Install

```sh
helm install pgweb ectobit/pgweb
```

## Helmfile

```yaml
releases:
  - name: pgweb
    chart: ectobit/pgweb
    namespace: default
    values:
      - ingress:
          enabled: true
          annotations:
            kubernetes.io/ingress.class: nginx
          hosts:
            - host: pgweb.your-domain.com
              paths:
                - path: /
                  pathType: Prefix
          tls:
            - secretName: your-domain-com-tls
              hosts:
                - pgweb.your-domain.com
```

**Homepage:** <https://github.com/ectobit/charts>

## Source Code

- <https://github.com/ectobit/charts/tree/main/pgweb>
- <https://github.com/sosedoff/pgweb>

## Values

| Key                                        | Type   | Default                                                                                       | Description                                                                    |
| ------------------------------------------ | ------ | --------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------ |
| affinity                                   | object | `{}`                                                                                          |                                                                                |
| autoscaling.enabled                        | bool   | `false`                                                                                       |                                                                                |
| autoscaling.maxReplicas                    | int    | `100`                                                                                         |                                                                                |
| autoscaling.minReplicas                    | int    | `1`                                                                                           |                                                                                |
| autoscaling.targetCPUUtilizationPercentage | int    | `80`                                                                                          |                                                                                |
| fullnameOverride                           | string | `""`                                                                                          |                                                                                |
| image.pullPolicy                           | string | `"IfNotPresent"`                                                                              |                                                                                |
| image.repository                           | string | `"sosedoff/pgweb"`                                                                            |                                                                                |
| image.tag                                  | string | `""`                                                                                          |                                                                                |
| imagePullSecrets                           | list   | `[]`                                                                                          |                                                                                |
| ingress.annotations                        | object | `{}`                                                                                          |                                                                                |
| ingress.className                          | string | `""`                                                                                          |                                                                                |
| ingress.enabled                            | bool   | `false`                                                                                       |                                                                                |
| ingress.hosts                              | list   | `[{"host":"chart-example.local","paths":[{"path":"/","pathType":"ImplementationSpecific"}]}]` | kubernetes.io/tls-acme: "true"                                                 |
| ingress.tls                                | list   | `[]`                                                                                          |                                                                                |
| nameOverride                               | string | `""`                                                                                          |                                                                                |
| nodeSelector                               | object | `{}`                                                                                          |                                                                                |
| podAnnotations                             | object | `{}`                                                                                          |                                                                                |
| podSecurityContext                         | object | `{}`                                                                                          |                                                                                |
| replicaCount                               | int    | `1`                                                                                           |                                                                                |
| resources                                  | object | `{}`                                                                                          |                                                                                |
| securityContext                            | object | `{}`                                                                                          |                                                                                |
| service.port                               | int    | `80`                                                                                          |                                                                                |
| service.type                               | string | `"ClusterIP"`                                                                                 |                                                                                |
| serviceAccount.annotations                 | object | `{}`                                                                                          |                                                                                |
| serviceAccount.create                      | bool   | `true`                                                                                        |                                                                                |
| serviceAccount.name                        | string | `""`                                                                                          | If not set and create is true, a name is generated using the fullname template |
| tolerations                                | list   | `[]`                                                                                          |                                                                                |
