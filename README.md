# Docker image for ROSE compiler infrastructure

## Getting Started

Before the building you should clone this repository and have Docker installed on your computer.

## Building

You can build the image using Dockerfile from the project root. For example, with command below.

```
sudo docker build -t rose .
```

Or simply run _build.sh_ script which installs docker (if it is not already installed) and builds the image with command above.

This step might take about two hours, depending on your machine configuration.

## Using

The easiest way is to use it from shell:

```
sudo docker run  --rm -it rose sh
```

Or you can run ROSE utils directly but do not forget to [mount](https://docs.docker.com/storage/volumes/) local paths into container. For instance the command below runs container with ROSE, mounts current working directory to container's /root and executes indetityTranslator tool on main.cpp. Resulting files will be stored in current working directory, container will be deleted due to --rm option.

```
sudo docker run --rm -it -v $(pwd):/root rose identityTranslator -c main.cpp
```

## Publishing

To publish the image you should an account on [Docker Hub](https://hub.docker.com/) or any other Docker Registry (e.g. Gitlab provides one). Before publishing you should create alias for the image containing path to your registry (Docker Hub is default), path to your folder (which often contains username), image name, and optional tag.

```
sudo docker tag rose username/rose
sudo docker push username/rose
```

Package username/rose will be available for the other registry users.

## How to download an image

The easiest way is to use rose with docker is just download an image ready. You can easily access an image using the following command:

```
docker pull gleisonsdm/rose:latest
```

## Using the image

The easiest way is to use it from shell:

```
sudo docker run --rm -it -v $(pwd):/root gleisonsdm/rose sh
```

Or you can run ROSE utils directly but do not forget to [mount](https://docs.docker.com/storage/volumes/) local paths into container. For instance the command below runs container with ROSE, mounts current working directory to container's /root and executes indetityTranslator tool on main.cpp. Resulting files will be stored in current working directory, container will be deleted due to --rm option.

```
sudo docker run --rm -it -v $(pwd):/root gleisonsdm/rose identityTranslator -c main.cpp

