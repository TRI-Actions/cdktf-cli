#!/bin/bash
pipenv install
cd $1
cdktf diff --refresh-only --no-color > plan.out

INDEX=$(awk '/Note: Objects have changed/{ print NR; exit }' plan.out)

echo $INDEX

if [[ $INDEX ]]; then
  echo "drift-status=DRIFTED" >> $GITHUB_OUTPUT
else
  echo "drift-status=IN-SYNC" >> $GITHUB_OUTPUT
fi

echo $GITHUB_OUTPUT
echo Done!

exit
