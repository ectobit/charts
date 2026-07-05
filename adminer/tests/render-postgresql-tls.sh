#!/usr/bin/env bash

set -euo pipefail

rendered="$(helm template adminer ./adminer \
  --set postgresqlTls.enabled=true \
  --set postgresqlTls.secretName=adminer-postgresql-ca \
  --set postgresqlTls.mountPath=/etc/postgresql-tls \
  --set postgresqlTls.caKey=ca.crt \
  --set postgresqlTls.sslMode=verify-ca \
  --set env.ADMINER_DEFAULT_SERVER=postgresql)"

assert_contains() {
  local needle="$1"

  if ! grep -Fq "$needle" <<<"$rendered"; then
    echo "Expected rendered chart to contain: $needle" >&2
    exit 1
  fi
}

assert_contains 'name: adminer-postgresql-tls-plugin'
assert_contains '001-postgresql-login-ssl.php: |'
assert_contains "require_once('plugins/login-ssl.php');"
assert_contains "return new AdminerLoginSsl(['mode' => 'verify-ca']);"
assert_contains 'name: "ADMINER_DEFAULT_SERVER"'
assert_contains 'value: "postgresql"'
assert_contains 'name: "PGSSLMODE"'
assert_contains 'value: "verify-ca"'
assert_contains 'name: "PGSSLROOTCERT"'
assert_contains 'value: "/etc/postgresql-tls/ca.crt"'
assert_contains 'name: postgresql-tls'
assert_contains 'mountPath: "/etc/postgresql-tls"'
assert_contains 'readOnly: true'
assert_contains 'secretName: "adminer-postgresql-ca"'
assert_contains 'name: postgresql-tls-plugin'
assert_contains 'mountPath: /var/www/html/plugins-enabled/001-postgresql-login-ssl.php'
