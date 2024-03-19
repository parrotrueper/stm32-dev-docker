# Host Setup: Ubuntu 20.04 Host Machine

## Requirements

* Install Docker Engine, [helper script here](https://github.com/parrotrueper/docker-install)

## Setup the GDB Server 

In order to be able to debug from the Docker container we will connect to a
GDB server. On the host or the machine connected to the hardware.

1. Download and install the *STM32CubeCLT-Lnx* from the [ST website](www.st.com). 

    Install this in `/opt/` as our helper scripts are expecting the GDB server 
    to be in: `/opt/st/stm32cubectl/STLink-gdb-server/bin`


2. Setup the dev environment.

    Open a terminal and run the following script

    `./dev-scripts/env-setup`

    log out and log back in


