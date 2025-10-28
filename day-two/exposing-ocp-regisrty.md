 # Configure & expose the internal registry.
    
    # check if the image service is running or not; managementstate should be removed and no pods should be present:
        oc get pod -n openshift-image-registry -l docker-registry=default
        oc get configs.imageregistry.operator.openshift.io -o yaml | grep managementState
        
    # patch image to use emptydir not recommended for production and also everything will be lost if the image service restart:
        oc patch configs.imageregistry.operator.openshift.io cluster --type merge --patch '{"spec":{"storage":{"emptyDir":{}}}}'
        
    # patch the image service to start:
        oc patch configs.imageregistry.operator.openshift.io cluster --type merge --patch '{"spec":{"managementState":"Managed"}}'

    # Verify if that everything is running properly:
        oc get pod -n openshift-image-registry -l docker-registry=default
        oc get configs.imageregistry.operator.openshift.io -o yaml | grep managementState
        
    # expose the registry:
        oc patch configs.imageregistry.operator.openshift.io/cluster --patch '{"spec":{"defaultRoute":true}}' --type=merge
        
    # get registry route end-point:
        oc get route default-route -n openshift-image-registry --template='{{ .spec.host }}'
   
# Upload an image to the internal registry with Self signed CA

    # login into one of your nodes and trust the cluster default certificate:

         - extract the ingress certificate:
                oc extract secret/$(oc get ingresscontroller -n openshift-ingress-operator default -o json | jq '.spec.defaultCertificate.name // "router-certs-default"' -r) -n openshift-ingress --confirm
            
        - move the ca into the node trust-store and update it:
                sudo mv tls.crt /etc/pki/ca-trust/source/anchors/ && sudo update-ca-trust enable
        
        - login into the registry:
            (optional )HOST=$(oc get route default-route -n openshift-image-registry --template='{{ .spec.host }}')
                   This has not been working lately. For some reason podman default to login to registry.access.redhat.com, hence resulting into an auth error when trying to push the image into the local registry since authentication was not done to begin with.
                   
             podman login -u kubeadmin -p $(oc whoami -t) default-route-openshift-image-registry.apps.cs-ent.opsgn.lan
        
        - push the vddk image into the openshift-mtv namespace:
             podman push imageID default-route-openshift-image-registry.apps.ent.opsgn.lan/virtual-machines/vddk
