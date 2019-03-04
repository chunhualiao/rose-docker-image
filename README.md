# Docker image for ROSE compiler infrastructure

## Getting Started

Before the building you should clone this repository and have Docker installed on your computer.

## Building

You can build the image using Dockerfile from the project root. For example, with command below.

```
sudo docker build -t rose .
```

This step might take a lot of time.

## Using

The easiest way is to use it from shell:

```
sudo docker run rose sh
```

Or you can run ROSE utils directly but do not forget to [mount](https://docs.docker.com/storage/volumes/) local paths into container.
