#!/bin/bash

srcfile="./dev-scripts/source-me.sh"
if [[ ! -e "${srcfile}" ]]; then 
    echo "ERROR:"
    echo "${srcfile} NOT FOUND!"
    exit 1
fi
source $srcfile
printf "To launch STM32 IDE:\n\n"
printf "$ stm32cubeide&\n\n"

# uncomment if you want to launch automatically on entry
# stm32cubeide&
