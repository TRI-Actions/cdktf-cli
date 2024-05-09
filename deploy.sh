#!/bin/bash
export CI=1
cd $1
cdktf deploy --auto-approve --no-color > deploy.out

exit
