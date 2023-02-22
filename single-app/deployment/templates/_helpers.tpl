{{- define "node-bloom-filter.labels" -}}
{{- include "node-bloom-filter.selectorLabels" . }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
env: {{ .Values.env }}
{{- end }}

{{- define "node-bloom-filter.selectorLabels" -}}
app: {{ .Chart.Name }}
release: {{ .Release.Name }}
{{- end }}

{{- define "node-bloom-filter.n_items" -}}
{{- if eq .Values.env "production" -}}
"200000"
{{- else -}}
"100000"
{{- end -}}
{{- end -}}