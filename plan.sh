#!/bin/bash
echo Installing dependencies
pipenv install
cd $1
echo Running plan in for $1
cdktf diff --refresh-only --no-color > plan.out

INDEX=$(awk '/Note: Objects have changed/{ print NR; exit }' plan.out)

if [[ $INDEX ]]; then
  echo Drift Detected!
  echo "drift-status=DRIFTED" >> $GITHUB_OUTPUT
else
  echo No drift detected!
  echo "drift-status=IN-SYNC" >> $GITHUB_OUTPUT
fi

echo Done!

exit
