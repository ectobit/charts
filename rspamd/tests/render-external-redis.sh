#!/usr/bin/env bash
set -euo pipefail

chart_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
tmp_dir="$(mktemp -d)"
trap 'rm -rf "${tmp_dir}"' EXIT

assert_contains() {
  local file="$1"
  local pattern="$2"

  if ! grep -Fq -- "$pattern" "$file"; then
    echo "expected ${file} to contain: ${pattern}" >&2
    return 1
  fi
}

assert_not_contains() {
  local file="$1"
  local pattern="$2"

  if grep -Fq -- "$pattern" "$file"; then
    echo "expected ${file} not to contain: ${pattern}" >&2
    return 1
  fi
}

helm template rspamd "$chart_dir" >"${tmp_dir}/default.yaml"
assert_not_contains "${tmp_dir}/default.yaml" "redis.conf: |"
assert_not_contains "${tmp_dir}/default.yaml" "history_redis.conf: |"

helm template rspamd "$chart_dir" --set redis.enabled=true >"${tmp_dir}/embedded.yaml"
assert_contains "${tmp_dir}/embedded.yaml" 'redis.conf: |'
assert_contains "${tmp_dir}/embedded.yaml" 'servers = "rspamd-redis-master";'
assert_contains "${tmp_dir}/embedded.yaml" 'history_redis.conf: |'
assert_contains "${tmp_dir}/embedded.yaml" 'servers = rspamd-redis-master:6379;'
assert_contains "${tmp_dir}/embedded.yaml" 'mountPath: /etc/rspamd/local.d/redis.conf'
assert_contains "${tmp_dir}/embedded.yaml" 'mountPath: /etc/rspamd/local.d/history_redis.conf'

cat >"${tmp_dir}/external-values.yaml" <<'VALUES'
redis:
  enabled: false

externalRedis:
  enabled: true
  host: valkey.db.svc.cluster.local
  port: 6379
  db: "0"
  username: rspamd
  existingSecret: rspamd-valkey
  existingSecretPasswordKey: password
  tls:
    enabled: true
    existingSecret: valkey-ca
    caFilename: ca.crt
    certFilename: tls.crt
    certKeyFilename: tls.key
    sni: valkey.db.svc.cluster.local
VALUES

helm template rspamd "$chart_dir" -f "${tmp_dir}/external-values.yaml" >"${tmp_dir}/external.yaml"
assert_contains "${tmp_dir}/external.yaml" 'kind: Secret'
assert_contains "${tmp_dir}/external.yaml" 'name: rspamd-redis-config'
assert_contains "${tmp_dir}/external.yaml" 'servers = "valkey.db.svc.cluster.local:6379";'
assert_contains "${tmp_dir}/external.yaml" 'db = "0";'
assert_contains "${tmp_dir}/external.yaml" 'username = "rspamd";'
assert_not_contains "${tmp_dir}/external.yaml" 'password = "$REDIS_PASSWORD";'
awk '
  /^# Source: rspamd\/templates\/redis-secret.yaml$/ { in_secret = 1 }
  /^---$/ && in_secret { in_secret = 0 }
  in_secret && /password = / { found = 1 }
  END { exit found ? 1 : 0 }
' "${tmp_dir}/external.yaml" || {
  echo "expected existingSecret Redis template Secret not to contain a password line" >&2
  exit 1
}
assert_contains "${tmp_dir}/external.yaml" 'name: render-redis-config'
assert_contains "${tmp_dir}/external.yaml" 'cp /redis-template/redis.conf /redis-config/redis.conf'
assert_contains "${tmp_dir}/external.yaml" 'cp /redis-template/history_redis.conf /redis-config/history_redis.conf'
assert_contains "${tmp_dir}/external.yaml" 'mountPath: /redis-template'
assert_contains "${tmp_dir}/external.yaml" 'mountPath: /redis-config'
assert_contains "${tmp_dir}/external.yaml" 'name: redis-config-rendered'
assert_contains "${tmp_dir}/external.yaml" 'emptyDir: {}'
assert_contains "${tmp_dir}/external.yaml" 'ssl = true;'
assert_contains "${tmp_dir}/external.yaml" 'ssl_ca = "/etc/rspamd/redis-tls/ca.crt";'
assert_contains "${tmp_dir}/external.yaml" 'ssl_cert = "/etc/rspamd/redis-tls/tls.crt";'
assert_contains "${tmp_dir}/external.yaml" 'ssl_key = "/etc/rspamd/redis-tls/tls.key";'
assert_contains "${tmp_dir}/external.yaml" 'sni = "valkey.db.svc.cluster.local";'
assert_contains "${tmp_dir}/external.yaml" 'name: REDIS_PASSWORD'
assert_contains "${tmp_dir}/external.yaml" 'name: rspamd-valkey'
assert_contains "${tmp_dir}/external.yaml" 'key: password'
assert_contains "${tmp_dir}/external.yaml" 'name: redis-tls'
assert_contains "${tmp_dir}/external.yaml" 'secretName: valkey-ca'
assert_contains "${tmp_dir}/external.yaml" 'mountPath: /etc/rspamd/redis-tls'
assert_contains "${tmp_dir}/external.yaml" 'mountPath: /etc/rspamd/local.d/redis.conf'
assert_contains "${tmp_dir}/external.yaml" 'mountPath: /etc/rspamd/local.d/history_redis.conf'
assert_contains "${tmp_dir}/external.yaml" 'subPath: redis.conf'
assert_contains "${tmp_dir}/external.yaml" 'subPath: history_redis.conf'
assert_contains "${tmp_dir}/external.yaml" 'checksum/redis-config:'
assert_contains "${tmp_dir}/external.yaml" 'checksum/external-redis-secret:'
awk '
  /^kind: ConfigMap$/ { in_configmap = 1 }
  /^---$/ { in_configmap = 0 }
  in_configmap && /password = / { found = 1 }
  END { exit found ? 1 : 0 }
' "${tmp_dir}/external.yaml" || {
  echo "expected ConfigMaps not to contain Redis passwords" >&2
  exit 1
}
assert_not_contains "${tmp_dir}/external.yaml" 'no_ssl_verify = true;'

cat >"${tmp_dir}/external-insecure-values.yaml" <<'VALUES'
redis:
  enabled: false

externalRedis:
  enabled: true
  host: valkey.db.svc.cluster.local
  tls:
    enabled: true
    noVerify: true
VALUES

helm template rspamd "$chart_dir" -f "${tmp_dir}/external-insecure-values.yaml" >"${tmp_dir}/external-insecure.yaml"
assert_contains "${tmp_dir}/external-insecure.yaml" 'no_ssl_verify = true;'

cat >"${tmp_dir}/external-inline-password-values.yaml" <<'VALUES'
redis:
  enabled: false

externalRedis:
  enabled: true
  host: valkey.db.svc.cluster.local
  password: inline-secret
VALUES

helm template rspamd "$chart_dir" -f "${tmp_dir}/external-inline-password-values.yaml" >"${tmp_dir}/external-inline-password.yaml"
assert_contains "${tmp_dir}/external-inline-password.yaml" 'kind: Secret'
assert_contains "${tmp_dir}/external-inline-password.yaml" 'name: rspamd-redis-config'
assert_contains "${tmp_dir}/external-inline-password.yaml" 'password = "inline-secret";'
awk '
  /^kind: ConfigMap$/ { in_configmap = 1 }
  /^---$/ { in_configmap = 0 }
  in_configmap && /password = / { found = 1 }
  END { exit found ? 1 : 0 }
' "${tmp_dir}/external-inline-password.yaml" || {
  echo "expected ConfigMaps not to contain inline Redis passwords" >&2
  exit 1
}

cat >"${tmp_dir}/external-passwordless-values.yaml" <<'VALUES'
redis:
  enabled: false

externalRedis:
  enabled: true
  host: valkey.db.svc.cluster.local
VALUES

helm template rspamd "$chart_dir" -f "${tmp_dir}/external-passwordless-values.yaml" >"${tmp_dir}/external-passwordless.yaml"
assert_contains "${tmp_dir}/external-passwordless.yaml" 'kind: Secret'
assert_contains "${tmp_dir}/external-passwordless.yaml" 'servers = "valkey.db.svc.cluster.local:6379";'
assert_not_contains "${tmp_dir}/external-passwordless.yaml" 'password = '
assert_not_contains "${tmp_dir}/external-passwordless.yaml" 'name: render-redis-config'

if helm template rspamd "$chart_dir" --set redis.enabled=true --set externalRedis.enabled=true >"${tmp_dir}/both.yaml" 2>"${tmp_dir}/both.err"; then
  echo "expected embedded and external Redis together to fail" >&2
  exit 1
fi
assert_contains "${tmp_dir}/both.err" "redis.enabled and externalRedis.enabled cannot both be true"

if helm template rspamd "$chart_dir" --set redis.enabled=true --set redis.auth.enabled=true >"${tmp_dir}/redis-auth.yaml" 2>"${tmp_dir}/redis-auth.err"; then
  echo "expected embedded Redis auth to fail until Rspamd password rendering is supported" >&2
  exit 1
fi
assert_contains "${tmp_dir}/redis-auth.err" "redis.auth.enabled is not supported by this chart"

helm template rspamd "$chart_dir" --set config.workerController.password=controller-secret >"${tmp_dir}/controller-password.yaml"
assert_contains "${tmp_dir}/controller-password.yaml" 'kind: Secret'
assert_contains "${tmp_dir}/controller-password.yaml" 'name: rspamd-controller-config'
assert_contains "${tmp_dir}/controller-password.yaml" 'password = "controller-secret";'
assert_contains "${tmp_dir}/controller-password.yaml" 'secretName: rspamd-controller-config'
awk '
  /^kind: ConfigMap$/ { in_configmap = 1 }
  /^---$/ { in_configmap = 0 }
  in_configmap && /controller-secret/ { found = 1 }
  END { exit found ? 1 : 0 }
' "${tmp_dir}/controller-password.yaml" || {
  echo "expected ConfigMaps not to contain controller passwords" >&2
  exit 1
}

helm template rspamd "$chart_dir" --set persistence.enabled=true >"${tmp_dir}/pvc.yaml"
awk '
  /^# Source: rspamd\/templates\/pvc.yaml$/ { in_pvc = 1 }
  /^---$/ && in_pvc { in_pvc = 0 }
  in_pvc && /^  annotations:$/ { found = 1 }
  END { exit found ? 1 : 0 }
' "${tmp_dir}/pvc.yaml" || {
  echo "expected PVC not to render empty annotations" >&2
  exit 1
}
