# Setup a Litecoin node

This is meant to be a quick way to setup a Litecoin node from scratch. Yes, this compiles the code and does not download Litecoin binaries.

## Docker 

TL;DR Docker is awesome and you should learn more about it.

Docker is a powerful virtualizaton tool which you can use to set something up real quick and have it isolated from your host environment. The separate environment that docker sets up is usually termed a "container".

I find it super useful since you could iteratively improve upon your container and along the way really understand what works and does not work and why or why not.

You can also create new containers that inherit from existing containers.

I found it extremely useful to setup a Litecoin node within a container since by doing it once using docker, I would avoid reinventing the wheel every time and also isolate myself from issues related to the host OS such as library version conflicts, unavailability of certain libraries etc.

My Litecoin Dockerfile only pulls in the dependencies that are needed for Litecoin, pulls the source code from the official Litecoin Github, checks out a release version and compiles it from source! It then installs it and runs the compiled binaries.

## Install Docker

Please follow the instructions at https://docs.docker.com/install/ to install Docker for your system.

## Clone this repository

`git clone https://github.com/crypto-b612/litecoin-docker.git`
`cd litecoin-docker`

## Blockchain storage

You need to set aside some space for downloading and storing the Litecoin blockchain. Currently (01/30/2018), its around 14GB.

## Creating the container

Assuming you are already in the *litecoin-docker* directory:

`docker build -t litecoin .`

This will download all the dependencies, the code, compile the code, install the Litecoin binaries etc.

All of that will be in a new docker container image. You can verify that a new container was created by:

`docker images -a | grep litecoin`

## Running the container

Suppose you chose some external storage for Litecoin blockchain and the path to the directory that should have Litecoin blockchain and other persistent data is */media/External/litecoin-data*, then:

`cd /media/External/litecoin-data`
`touch litecoin.conf`

The above just creates an empty litecoin.conf configuration file.

`docker run --rm -it -v /media/External/litecoin-data:/home/litecoin/.litecoin -p 9333:9333 --name=litecoin litecoin`

The above will start up the container and make sure that port 9333 which will be used by other Litecoin peers to connect to our Litecoin node is setup such that the host will forward incoming traffic for that port to the Litecoin container.

Of course, you will also need to make sure that you forward port 9333 on your router to the host machine the container is running on if you are behind a NAT (which is true for most people).
