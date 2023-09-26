{{/* ArgoCD annotations */}}

# {{- define "lvm.sync-wave.labels" }}
#   annotations:
#     argocd.argoproj.io/sync-wave: {{ add 1 | quote }}
# {{- end }}


{{- define "lvm.sync-options.labels" }}
  annotations:
    argocd.argoproj.io/sync-wave: {{ add 3 | quote }}
    argocd.argoproj.io/sync-options: SkipDryRunOnMissingResource=true
{{- end }}

