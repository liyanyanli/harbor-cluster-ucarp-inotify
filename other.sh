#!/bin/bash

release=/release

cd $1/build

sudo cp ..$release/analyze-local-images /bin

sudo cp ..$release/docker-compose /usr/local/bin

sudo chmod +x /bin/analyze-local-images

sudo chmod +x /usr/local/bin/docker-compose
