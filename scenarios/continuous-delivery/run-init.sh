# ssh root@host01 "oadm new-project infra --display-name='Workshop Infra'"
# ssh root@host01 "oc process -f http://bit.ly/openshift-gogs-persistent-template --param=HOSTNAME=gogs-infra..environments.katacoda.com --param=GOGS_VERSION=0.9.113 --param=SKIP_TLS_VERIFY=true -n infra | oc create -f - -n infra"
