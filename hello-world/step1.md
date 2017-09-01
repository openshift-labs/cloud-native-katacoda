`oc get nodes`{{execute}}


`curl -ksLO https://raw.githubusercontent.com/openshift/origin/master/examples/hello-openshift/hello-pod.json`{{execute}}


`oc apply -f hello-pod.json`{{execute}}


`oc get pods`{{execute}}


https://[[HOST_SUBDOMAIN]]-8443-[[KATACODA_HOST]].environments.katacoda.com
