#!/bin/bash
export CI=1

for i in $WORKDIRS; do
  cd $i
  echo Deploying for $i
  cdktf deploy --auto-approve --no-color > deploy.out
  cd ..
done

exit
