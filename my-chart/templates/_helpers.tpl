{{/*
Expand the name of the chart.
*/}}
{{- define "app-chart.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "app-chart.fullname" -}}
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
Create the chart reference string.
*/}}
{{- define "app-chart.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels that will be applied to every resource.
*/}}
{{- define "app-chart.labels" -}}
helm.sh/chart: {{ include "app-chart.chart" . }}
app.kubernetes.io/name: {{ include "app-chart.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
{{- end -}}

{{/*
Component-specific labels. This is the key to fixing selectors.
It includes all common labels and adds component-specific ones.
Usage:
{{- include "app-chart.componentLabels" (dict "root" . "componentName" "nginx-frontend-v1" "versionLabel" "v1") | nindent 4 }}
*/}}
{{- define "app-chart.componentLabels" -}}
{{- include "app-chart.labels" .root }}
app.kubernetes.io/component: {{ .componentName }}
{{- if .versionLabel }}
version: {{ .versionLabel }}
{{- end }}
{{- /* This common label is for the nginx service to select BOTH v1 and v2 pods */}}
{{- if (hasPrefix "nginx-frontend" .componentName) }}
app-role: nginx-frontend
{{- end }}
{{- end }}


{{/*
Generate the full image name including registry and tag.
*/}}
{{- define "app-chart.imageName" -}}
{{- $registry := .global.imageRegistry | default "." -}}
{{- $repository := .componentImage.repository -}}
{{- $tag := .componentImage.tag | default .global.defaultTag -}}
{{- printf "%s/%s:%s" $registry $repository $tag }}
{{- end }}
