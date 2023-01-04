#!/bin/bash

source config

# Downloader
screen -S PB-Utils      -d -m ${BASEPATH}/scripts/relaunch.sh ${BASEPATH}/scripts/Downloader.os "${BASEPATH}/resources/downloads/"

