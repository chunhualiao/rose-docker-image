# Docker image for ROSE compiler infrastructure

## Getting Started

Before the building you should clone this repository and have Docker installed on your computer.

Docker intallation instructions:
```
sudo apt update
sudo apt upgrade
sudo apt install apt-transport-https ca-certificates curl software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
sudo apt update
     
sudo apt install docker-ce
# check if docker service is started
sudo systemctl status docker
```

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

The easiest way is to use rose with docker is just download an image which is ready to use (built by Gleison). You can easily access an image using the following command:

```sh
sudo docker pull gleisonsdm/rose:latest
```

## Using the image

The easiest way to use the image is running bash commands directly. You can find the binaries at "/usr/rose/bin/" ready to run. Please, check this using the follow command line:

```sh
sudo docker run --rm -it -v $(pwd):/root gleisonsdm/rose:latest ls /usr/rose/bin
```

Then, the expected output is:

```sh
ArrayProcessor			  interproceduralCFG
DataFaultToleranceTransformation  libtool
KeepGoingTranslator		  livenessAnalysis
astCopyReplTest			  loopProcessor
astRewriteExample1		  mangledNameDumper
autoPar				  measureTool
autoTuning			  moveDeclarationToInnermostScope
buildCallGraph			  outline
codeInstrumentor		  pdfGenerator
compassEmptyMain		  preprocessingInfoDumper
compassMain			  qualifiedNameDumper
compassVerifier			  rajaChecker
defaultTranslator		  rose-config
defuseAnalysis			  roseupcc
dotGenerator			  sampleCompassSubset
dotGeneratorWholeASTGraph	  summarizeSignatures
extractMPISkeleton		  typeforge
generateSignatures		  virtualCFG
identityTranslator
```

The next step is check if your docker image is working correctly, you can run identityTranslator in a program as a test. We suggest you to run a hello world, as the code provided below:

```cpp
#include <iostream>

int main() {
  std::cout << "Hello World!\n";
  return 0;
}
```

After save this code in a file named "main.cpp", you are able to run ROSE utils directly, but do not forget to [mount](https://docs.docker.com/storage/volumes/) local paths into container. For instance the command below runs container with ROSE, mounts current working directory to container's /root and executes indetityTranslator tool on main.cpp. Resulting files will be stored in current working directory, container will be deleted due to --rm option.

```sh
sudo docker run --rm -it -v $(pwd):/root gleisonsdm/rose identityTranslator -c main.cpp
```

In the end, your current directory contains new files, as listed bellow:
* main.o
* rose_main.cpp

