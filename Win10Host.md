# Host Setup: Windows 10 Host

## Requirements

* WSL2 Ubuntu 20.04. [Setup helper scripts here](https://github.com/parrotrueper/wsl2-install)
* Install Docker Engine on WSL2, [helper script here](https://github.com/parrotrueper/docker-install)


## Setup the GDB Server on Windows

In order to be able to debug from the Docker container we will connect to a
GDB server. On the host or the machine connected to the hardware.

1. Download and install the *STM32CubeCLT-Win* from the [ST website](www.st.com). 

    Install this in `C:\ST` as our helper scripts are expecting the GDB server to be in: `C:\ST\STM32CubeCLT\STLink-gdb-server\bin`


2. Setup the dev environment

    Open a WSL2 terminal and navigate to where you cloned this repository and
    run the script:

    `./dev-scripts/env-setup`

    This script will

    * install dependencies on WSL
    * Set dialout permissions for the user

