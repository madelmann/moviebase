#!/bin/bash

source config

tmux new-session -s utils -d -n "PB-UTILS"

# Downloader
tmux new-window -t utils -n "Downloader"      ${BASEPATH}/scripts/relaunch.sh ${BASEPATH}/scripts/Downloader.os "${BASEPATH}/resources/downloads/"

