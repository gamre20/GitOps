{{/* ArgoCD annotations */}}

# {{- define "nmstate.labels" }}
#   annotations:
#     argocd.argoproj.io/sync-wave: {{ add 1 | quote }}
# {{- end }}


{{- define "nmstate.sync-options.labels" }}
  annotations:
    argocd.argoproj.io/hook: PostSync
    argocd.argoproj.io/sync-options: SkipDryRunOnMissingResource=true
{{- end }}
