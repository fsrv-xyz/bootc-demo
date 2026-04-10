image = ghcr.io/fsrv-xyz/bootc-demo:latest

build:
	podman build -t $(image) -f Containerfile .

push: build
	podman push $(image)

