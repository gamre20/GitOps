{{/* ArgoCD annotations */}}

# {{- define "kubevirt.labels" }}
#   annotations:
#     argocd.argoproj.io/sync-wave: {{ add 1 | quote }}
# {{- end }}


{{- define "kubevirt.sync-options.labels" }}
  annotations:
    argocd.argoproj.io/sync-wave: {{ add 3 | quote }}
    argocd.argoproj.io/sync-options: SkipDryRunOnMissingResource=true
    argocd.argoproj.io/hook: PostSync
{{- end }}

