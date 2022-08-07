#!/bin/bash

for f in plugins/*; do
	echo "Fixing permissions in $f..."
	chmod +x $f/*.os
done

