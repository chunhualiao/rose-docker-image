# Docker image for ROSE compiler infrastructure

## Getting Started

Before the building you should clone this repository and have Docker installed on your computer.

## Preparing Java 7

Before building the image you should download both Java Delopment Kit and Java Runtime Environment from [here](https://www.oracle.com/technetwork/java/javase/downloads/java-archive-downloads-javase7-521261.html) and put them into jdk/ and jre/ folders respectively. So that compiler will be in jdk/bin/javac and runtime in jre/bin/java.

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
