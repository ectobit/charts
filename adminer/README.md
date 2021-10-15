# adminer

Adminer Helm chart for Kubernetes

![Version: 0.1.1](https://img.shields.io/badge/Version-0.1.1-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 4.8.1](https://img.shields.io/badge/AppVersion-4.8.1-informational?style=flat-square) [![adminer](https://github.com/ectobit/charts/actions/workflows/adminer.yml/badge.svg)](https://github.com/ectobit/charts/actions/workflows/adminer.yml)

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

**Homepage:** <https://github.com/ectobit/charts>

## Source Code

- <https://github.com/ectobit/charts/tree/main/adminer>
- <https://github.com/TimWolla/docker-adminer>
- <https://github.com/vrana/adminer>

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
| image.repository                           | string | `"ectobit/adminer"`                                                                           |                                                                                |
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
