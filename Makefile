DOCKER_BUILDKIT=1
IMAGE_NAME="heussd/fivefilters-full-text-rss:3.8.1"

all: setup build clean

setup:
	docker buildx create --name "nubuilder" --use
build:
	docker buildx build --platform linux/amd64,linux/arm/v7,linux/arm/v6 -t $(IMAGE_NAME) --push .
clean:
	docker buildx rm nubuilder
