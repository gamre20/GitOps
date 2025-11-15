How to deploy Grafana:
    Openshift version 4.19

# Install the Grafana Operator from the OperatorHub in the OpenShift console in the "openshift-operators" namespace. Create the grafana CR with default values use the yaml view instead of the form view and click create. The below service account is created by the operator; add the necessary permissions to the service account.

  oc adm policy add-cluster-role-to-user openshift-cluster-monitoring-view -z grafana-a-sa -n openshift-operators
  oc adm policy add-role-to-user edit -z grafana-a-sa -n openshift-operators
  oc adm policy add-cluster-role-to-user cluster-monitoring-view -z grafana-a-sa -n openshift-operators

# Create a token for the service account to be used in the datasource configuration.
  oc create token grafana-a-sa --duration=8760h -n openshift-operators

# Update the below datasource yaml with the token created above and create the datasource. Note that spec.name is Prometheus with a capital P and the url is the internal Thanos Querier service. Once created look for into the CR yaml for a successful connection message. It takes a few minutes to sync in the grafana UI.

# create a route for the grafana-a-service in openshift-operators namespace to access grafana from outside the cluster.

apiVersion: grafana.integreatly.org/v1beta1
kind: GrafanaDatasource
metadata:
  name: prometheus-grafanadatasource
  namespace: openshift-operators
spec:
  datasource:
    jsonData:
      timeInterval: 5s
      tlsSkipVerify: true
      httpHeaderName1: 'Authorization'
    access: proxy
    isDefault: true
    name: Prometheus
    type: prometheus
    secureJsonData:
        httpHeaderValue1: 'Bearer <INSERT_TOKEN_HERE>'
    url: 'https://thanos-querier.openshift-monitoring.svc.cluster.local:9091'
  instanceSelector:
    matchLabels:
      dashboards: grafana-a # matching the label defined in the Grafana CR
  resyncPeriod: 10m0s
