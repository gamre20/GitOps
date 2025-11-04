{{- /* MTV source and destination provider definitions */}}
{{- define "mtv.provider" }}
  provider:
    source:
      name: {{ .Values.sourceProvider | default "mia-vsphere" }}
      namespace: {{ .Values.namespace | default "openshift-mtv" }}
    destination:
      name: {{ .Values.destinationProvider | default "host" }}
      namespace: {{ .Values.namespace | default "openshift-mtv" }}
{{ end -}}

{{- /* MTV plan options definitions */}}
{{- define "mtv.plan-options" }}
  archived: false
  skipGuestConversion: false
  pvcNameTemplateUseGeneratedName: true
  warm: false
  migrateSharedDisks: true
  useCompatibilityMode: true
  preserveStaticIPs: true
{{ end -}}
