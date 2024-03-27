# STM32IDE with ST-Link Debug in a Docker Container

This setup will allow you to spin up a docker container where you can use:

* The STMCubeIDE, run and debug your hardware from the container on the IDE.
* Do a headless build.
* Open your project in a dev container on VSC.


## Requirements

1. Download *STM32CubeIDE* for Linux from the [ST website](www.st.com) and place 
it in the `docker-data/linux-stm32-ide` directory of this repository. 

    The installer should be the amd64.deb_bundle version. For example:

    `en.st-stm32cubeide_1.15.0_20695_20240315_1429_amd64.deb_bundle.sh.zip`

2. Install the STLink GDB Server on the host (*STM32CubeCLTxxx*), depending on 
whether you are on Windows or Linux.

Setup [Windows Host](Win10Host.md) 

Setup [Linux Host](UbuntuHost.md)


## Build the Docker Image

Run the helper script

    `./dev-scripts/build-docker-img`

## Start the GDB Server (Optional).

If you have an STLink then connect it now, otherwise skip this step.

* Make a note of the host IP address. 
  
For WSL2: `/mnt/c/Windows/System32/ipconfig.exe`

Note that there will be IP addresses for your Windows host, WSL and Docker. You 
need the IP address of Windows, not WSL or Docker.
    
For Linux: `ip addr show`

Note that there will be IP addresses for your Linux host and for Docker. You need
the IP address of your host not Docker.

* Start the GDB Server with the following script.

    `./dev-scripts/gdbs-host`

* Leave the server running (to close it, use `Ctrl+C`).

## Copy Helper Scripts to your project

Open a Linux terminal (or WSL). Navigate to the desired path on the host from 
where your project files will be accessible, one level up from your sources. 
From that location run the `bring-scripts` script.

For example for an STM32 project in `~/projects/stm32/blinky`

```bash
cd ~/projects/stm32
/the/path/for/this/repo/dev-scripts/bring-scripts
```

This will create a directory with helper scripts on the host `dev-scripts`.

Here, helper scripts will be available for:

* Starting the GDB server on the host `./dev-scripts/gdbs-host`
* Running the container on the host `./dev-scripts/run-container`

## Run the container

`$ ./dev-scripts/run-container`

## From the Docker container

### Launch the STM32 IDE

`stm32cubeide&`

Log into your `st.com` account. Tick `Remember me on this computer`

### Setup the Debugger

For this to work the GDB server needs to be running on your host [see here](#start-the-gdb-server-optional).

* `Run -> Debug Configurations -> Debugger`
* `Host name or IP address`: IP address of the Host connected to the hardware
* `Connect to remote GDB server Port number`: 61234
* `Debug probe`: ST-LINK (ST-LINK GDB server)
* `Interface`: SWD

## Visual Studio Code and dev containers

For example for an STM32 project in `~/projects/stm32/blinky`

Copy scripts and `.devcontainer` to your project tree, for this example.

```bash
cd ~/projects/stm32
/the/path/for/this/repo/dev-scripts/bring-scripts
cp -r /the/path/for/this/repo/.devcontainer ./blinky/
```

Run the container.

`./dev-scripts/run-container`

Launch Visual Studio Code and open your project directory. For this example:

`~/projects/stm32/blinky`


Now attach to the running container. 

`VSC -> F1 -> Dev Containers -> Attach to Running Container`

Select the container `stm32_tchain:latest`.

Note you can assign a shortcut to `Attach to Running Container` by clicking on 
the cog that appears next to the command. I like to use `Ctrl + F7`

This will now launch a new instance of VSC.
Here you can open a terminal and you'll notice that you are in the container where you can do a headless build.

As this is a new shell you'll need to add the path to the binary or you can source the helper script.

```bash
source ../dev-scripts/source-me.sh  # adds /opt/st/stm32cubeide_xxx to your path
headless-build.sh -data ~/ -importAll ../blinky -cleanBuild blinky/Debug
```

The commands above are also available via a template script you can adapt to suit
your needs. See [project-build-headless-template](dev-scripts/project-build-headless-template) for details.

You will still able to debug from the ST IDE by launching it from the container 
terminal, or from the VSC terminal.

