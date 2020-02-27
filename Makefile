.PHONY: compile
.PHONY: build-image
.PHONY: build
.PHONY: deploy
BIN=build/server
TAG=1.3
IMAGE_TAG=pedropastor/pastor-server:$(TAG)
GCP_INSTANCE=pastor-server
compile:
	CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o $(BIN)
run:
	$(BIN)
build-image:
	docker build . --no-cache -t $(IMAGE_TAG) -f deploy/Dockerfile
run-image:
	docker run -d $(IMAGE_TAG)
push-image:
	docker push $(IMAGE_TAG)
local-up:
	export IMAGE_TAG=$(IMAGE_TAG) && \
	docker-compose -f deploy/docker-compose.yaml up -d && echo $(IMAGE_TAG)
local-down:
	docker-compose -f deploy/docker-compose.yaml down
update-instance:
	gcloud beta compute instances update-container $(GCP_INSTANCE) \
	--container-image docker.io/$(IMAGE_TAG)
build:
	make compile \
	&& make build-image	
deploy:
	make push-image \
	&& make update-instance
run-pipeline:
	make compile \
	&& make build-image \
	&& make push-image \
	&& make update-instance
