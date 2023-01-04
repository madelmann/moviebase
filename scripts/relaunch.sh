#!/bin/bash

echo "Starting relauncher..."

while [ true ]; do
	echo "Launching instance of '$1'..."

	$1
done

echo "Error: Relauncher has somehow been aborted!"

