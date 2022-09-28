#!/bin/bash

PLUGIN_NAME="spray-manager"

cd scripting
spcomp $PLUGIN_NAME.sp -o ../plugins/$PLUGIN_NAME.smx
