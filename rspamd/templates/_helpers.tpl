{{/*
Expand the name of the chart.
*/}}
{{- define "rspamd.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "rspamd.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "rspamd.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "rspamd.labels" -}}
helm.sh/chart: {{ include "rspamd.chart" . }}
{{ include "rspamd.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "rspamd.selectorLabels" -}}
app.kubernetes.io/name: {{ include "rspamd.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "rspamd.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "rspamd.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Validate mutually exclusive Redis modes.
*/}}
{{- define "rspamd.validateRedis" -}}
{{- if and .Values.redis.enabled .Values.externalRedis.enabled -}}
{{- fail "redis.enabled and externalRedis.enabled cannot both be true" -}}
{{- end -}}
{{- if .Values.externalRedis.enabled -}}
{{- if not .Values.externalRedis.host -}}
{{- fail "externalRedis.host is required when externalRedis.enabled is true" -}}
{{- end -}}
{{- if and .Values.externalRedis.password .Values.externalRedis.existingSecret -}}
{{- fail "externalRedis.password and externalRedis.existingSecret cannot both be set" -}}
{{- end -}}
{{- if and .Values.externalRedis.existingSecret (not .Values.externalRedis.existingSecretPasswordKey) -}}
{{- fail "externalRedis.existingSecretPasswordKey is required when externalRedis.existingSecret is set" -}}
{{- end -}}
{{- if and .Values.externalRedis.tls.enabled .Values.externalRedis.tls.certFilename (not .Values.externalRedis.tls.existingSecret) -}}
{{- fail "externalRedis.tls.existingSecret is required when externalRedis.tls.certFilename is set" -}}
{{- end -}}
{{- if and .Values.externalRedis.tls.enabled .Values.externalRedis.tls.certKeyFilename (not .Values.externalRedis.tls.existingSecret) -}}
{{- fail "externalRedis.tls.existingSecret is required when externalRedis.tls.certKeyFilename is set" -}}
{{- end -}}
{{- end -}}
{{- end }}

{{/*
Return true when either embedded or external Redis is enabled.
*/}}
{{- define "rspamd.redisEnabled" -}}
{{- if or .Values.redis.enabled .Values.externalRedis.enabled -}}true{{- end -}}
{{- end }}

{{/*
External Redis config Secret name.
*/}}
{{- define "rspamd.redisConfigSecretName" -}}
{{- printf "%s-redis-config" (include "rspamd.fullname" .) | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Redis config shared by Rspamd Redis modules.
*/}}
{{- define "rspamd.redisConfig" -}}
{{- if .Values.externalRedis.enabled -}}
{{- $port := default 6379 .Values.externalRedis.port -}}
servers = "{{ .Values.externalRedis.host }}:{{ $port }}";
{{- with .Values.externalRedis.db }}
db = {{ . | quote }};
{{- end }}
{{- with .Values.externalRedis.username }}
username = {{ . | quote }};
{{- end }}
{{- if or .Values.externalRedis.password .Values.externalRedis.existingSecret }}
password = {{ ternary "$REDIS_PASSWORD" .Values.externalRedis.password (not (empty .Values.externalRedis.existingSecret)) | quote }};
{{- end }}
{{- if .Values.externalRedis.tls.enabled }}
ssl = true;
{{- if and .Values.externalRedis.tls.existingSecret .Values.externalRedis.tls.caFilename }}
ssl_ca = "/etc/rspamd/redis-tls/{{ .Values.externalRedis.tls.caFilename }}";
{{- end }}
{{- if and .Values.externalRedis.tls.existingSecret .Values.externalRedis.tls.certFilename }}
ssl_cert = "/etc/rspamd/redis-tls/{{ .Values.externalRedis.tls.certFilename }}";
{{- end }}
{{- if and .Values.externalRedis.tls.existingSecret .Values.externalRedis.tls.certKeyFilename }}
ssl_key = "/etc/rspamd/redis-tls/{{ .Values.externalRedis.tls.certKeyFilename }}";
{{- end }}
{{- with .Values.externalRedis.tls.sni }}
sni = {{ . | quote }};
{{- end }}
{{- if .Values.externalRedis.tls.noVerify }}
no_ssl_verify = true;
{{- end }}
{{- end }}
{{- with .Values.externalRedis.timeout }}
timeout = {{ . | quote }};
{{- end }}
{{- else if .Values.redis.enabled -}}
servers = "{{ .Release.Name }}-redis-master";
{{- end -}}
{{- end }}

{{/*
Redis history config uses the same backend connection details.
*/}}
{{- define "rspamd.historyRedisConfig" -}}
{{- if .Values.redis.enabled -}}
servers = {{ .Release.Name }}-redis-master:6379;
{{- else -}}
{{ include "rspamd.redisConfig" . }}
{{- end }}
key_prefix = {{ .Values.config.historyRedis.keyPrefix | quote }};
nrows = {{ .Values.config.historyRedis.nrows }};
compress = {{ .Values.config.historyRedis.compress }};
subject_privacy = {{ .Values.config.historyRedis.subjectPrivacy }};
{{- with .Values.config.historyRedis.extraConfig }}
{{ . }}
{{- end }}
{{- end }}
