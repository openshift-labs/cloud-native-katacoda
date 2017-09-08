ssh root@host01 "yum install unzip -y; curl -sL -o projects.zip https://github.com/openshift-roadshow/cloud-native-labs/archive/master.zip && unzip -q projects.zip && mv cloud-native-labs-master/*/ . && rm -rf cloud-native-labs-master && rm -f projects.zip"

ssh root@host01 "oc new-project coolstore"