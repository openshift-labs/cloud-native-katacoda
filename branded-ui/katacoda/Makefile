NAME = openshift-roadshow/cloud-native-katacoda
INSTANCE = openshift-roadshow-cloud-native

.PHONY: default buildrelease build copy debug run release dev push

default: buildrelease

build:
	docker build -t $(NAME)-dev .

copy:
	docker create --name $(INSTANCE) $(NAME)-dev
	docker cp $(INSTANCE):/go/src/github.com/$(NAME)/main $(shell pwd)/app
	docker rm $(INSTANCE)

release:
	docker build -t $(NAME) -f Dockerfile-release .

buildrelease: build copy release

run:
	docker run --rm -v /var/run/docker.sock:/var/run/docker.sock -v /var/lib/docker/containers:/containers --name $(INSTANCE) $(NAME)

dev:
	docker run -it -p 3000:3000 --rm -w /go/src/github.com/$(NAME) \
	  -v $(shell pwd):/go/src/github.com/$(NAME) \
	  golang:1.7

start:	buildrelease
	docker-compose up -d
