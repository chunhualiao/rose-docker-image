#!/bin/bash

which docker > /dev/null || ( sudo apt-get update && sudo apt-get install -y docker )

sudo docker build -t rose .
