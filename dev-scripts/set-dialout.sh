#!/bin/bash
echo "--------------"
echo "${0##*/}"
echo "---------------"

echo "setting dialout permissions"
sudo usermod -a -G dialout $USER
sudo usermod -a -G tty $USER
echo ".................... done"
