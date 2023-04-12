# Einstein Toolkit Docker

> :warning: **WIP**: This is a work in progress.

## Overview

This guide demonstrates how to create and use a ready-to-use Einstein Toolkit image for running simulations in containers.

Credits: This Docker configuration is based on Erik Schnetter's original work, which can be found at [eschnett/einsteintoolkit-docker](https://github.com/eschnett/einsteintoolkit-docker). The repository has been forked and updated, as Erik no longer actively maintains it.

## How to set up

```bash
docker compose build

IMAGE=f6477d58b757
docker commit $IMAGE et-sourcetree

docker run $IMAGE build --debug
docker run -v Cactus:/home/scientist/Cactus
```


## Running Einstein Toolkit Simulations

1. Each Einstein Toolkit simulation runs in a container. Follow these steps to run a simulation:

```bash
docker run --name my-simulation -it einstein-toolkit
```

2. If needed, interact with the host system by mounting directories or forwarding ports when starting the container. For example:

docker run --name my-simulation -v /path/on/host/simulations:/root/simulations -it einstein-toolkit

3. To stop and remove the container once the simulation is complete, run:

```bash
docker rm -f my-simulation
```

