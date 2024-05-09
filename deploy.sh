#!/bin/bash
export CI=1
cd $WORKDIR
echo Deploying for $WORKDIR
cdktf deploy --auto-approve --no-color > deploy.out

exit
