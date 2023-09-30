{{/* ArgoCD annotations */}}

{{- define "argocd.finalizer.labels" }}
  finalizers:
  - resources-finalizer.argocd.argoproj.io
{{- end }}

