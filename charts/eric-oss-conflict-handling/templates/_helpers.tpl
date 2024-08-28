{{/*
Expand the name of the chart.
*/}}
{{- define "eric-oss-conflict-handling.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "eric-oss-conflict-handling.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create Ericsson product app.kubernetes.io info
*/}}
{{- define "eric-oss-conflict-handling.kubernetes-io-info" -}}
app.kubernetes.io/name: {{ .Chart.Name | quote }}
app.kubernetes.io/version: {{ .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" | quote }}
app.kubernetes.io/instance: {{ .Release.Name | quote }}
{{- end -}}

{{/*
Create annotation for the product information (DR-D1121-064, DR-D1121-067)
*/}}
{{- define "eric-oss-conflict-handling.product-info" }}
ericsson.com/product-name: {{ (fromYaml (.Files.Get "eric-product-info.yaml")).productName | quote }}
ericsson.com/product-number: {{ (fromYaml (.Files.Get "eric-product-info.yaml")).productNumber | quote }}
ericsson.com/product-revision: {{ regexReplaceAll "(.*)[+|-].*" .Chart.Version "${1}" | quote }}
{{- end}}

{{/*
Check global.security.tls.enabled
*/}}
{{- define "eric-oss-conflict-handling.global-security-tls-enabled" -}}
{{- if  .Values.global.security.tls -}}
   {{- .Values.global.security.tls.enabled | toString -}}
{{- else -}}
   {{- "false" -}}
{{- end -}}
{{- end -}}

{{/*
Create Service Mesh enabling option
*/}}
{{- define "eric-oss-conflict-handling.service-mesh.enabled" }}
  {{- $globalMeshEnabled := "false" -}}
  {{- if .Values.global -}}
    {{- if .Values.global.serviceMesh -}}
        {{- $globalMeshEnabled = .Values.global.serviceMesh.enabled -}}
    {{- end -}}
  {{- end -}}
  {{- $globalMeshEnabled -}}
{{- end -}}
