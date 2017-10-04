FROM golang:1.7
RUN mkdir -p /go/src/github.com/openshift-roadshow/cloud-native-katacoda
WORKDIR /go/src/github.com/openshift-roadshow/cloud-native-katacoda
ADD . /go/src/github.com/openshift-roadshow/cloud-native-katacoda
RUN go get && CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o main .
