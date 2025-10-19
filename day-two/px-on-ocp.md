Deploy portworx on Openshift with pure flash array.

# Need to patch machineconfig operator to enable multipathing in coreOS if not already enabled:
    https://github.com/cjkennedy1972/px-ocp-mco-multipath/blob/master/px-ocp-mco-multipathd.yaml

# Important architecture decision affecting your deployment
    https://docs.portworx.com/portworx-enterprise/reference-architectures/deployment-arch#approach-a-separate-storage-and-compute-clusters

# Create a storage admin account on the flasharray for portworx's authentication:
    https://docs.portworx.com/portworx-enterprise/platform/openshift/ocp-flasharray/install-flasharray/install-flasharray-cd#set-up-user-access-in-flasharray

# Create a JSON file "pure.json" containing the admin api key:
    https://docs.portworx.com/portworx-enterprise/platform/openshift/ocp-flasharray/install-flasharray/install-flasharray-cd#create-a-json-configuration-file

# Create the "portworx" namespace
    oc new-project portworx

# Create a secret named "px-pure-secret" in the above namespace based on the pure.json file
Secret might be only needed if you're going to make the CSI (API requests here) talk to the flasharray directly. Otherwise if presenting LUN to the nodes it might not be needed.
    oc create secret generic px-pure-secret --from-file=pure.json -n portworx

# Install the operator Portworx Enterprise in the namespace created above

# Obtain the portworx storage cluster config yaml:

     via https://central.portworx.com/landing/login
        - While creating the cluster config yaml you can choose LUN presented to the nodes ( Platform = DAS/SAN ) or pure backend ( Platform = pure flasharray ).

        - Cluster version need to match what's in the config yaml:
            oc get version

        - Important, add this annotation to your config file for compacted cluster:
            portworx.io/run-on-master: "true"

        - You can manage storage node by adding specific label to nodes in your cluster:
            https://docs.portworx.com/portworx-enterprise/reference-architectures/auto-disk-provisioning
        
        - Note that if you're deploying the CSI to directly talk to the flasharray then, there is no need to add node selector in your CR as the storage will be provisioned directly on the backend.
   
# optional

    - configure user monitoring:
        https://docs.redhat.com/en/documentation/openshift_container_platform/4.8/html/monitoring/enabling-monitoring-for-user-defined-projects#enabling-monitoring-for-user-defined-projects_enabling-monitoring-for-user-defined-projects:~:text=the%20pods%20often.-,Procedure,-Edit%20the%20cluster

    - configure auto pilot:
        https://docs.portworx.com/portworx-enterprise/operations/operate-kubernetes/monitoring/set-ocp-prometheus#configure-autopilot

    - find the thanos url with:
        oc get route thanos-querier -n openshift-monitoring -o json | jq -r '.spec.host'
        
    - Important Node labels:
        https://docs.portworx.com/portworx-enterprise/reference/node-labels

