{{/* ArgoCD annotations */}}

# {{- define "mtv.labels" }}
#   annotations:
#     argocd.argoproj.io/sync-wave: {{ add 1 | quote }}
# {{- end }}


{{- define "mtv.sync-options.labels" }}
  annotations:
    argocd.argoproj.io/hook: PostSync
    argocd.argoproj.io/sync-options: SkipDryRunOnMissingResource=true
{{- end }}

