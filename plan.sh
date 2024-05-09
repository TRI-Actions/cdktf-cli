#!/bin/bash
pipenv install
cd $1
cdktf diff --refresh-only --no-color > plan.out

INDEX=$(awk '/Note: Objects have changed/{ print NR; exit }' plan.out)
# sed -i "1,$((INDEX-1)) d" plan.out
echo $INDEX
echo "drift-status=DRIFTED" >> $GITHUB_OUTPUT
# if [[ $INDEX ]]; then
#   echo "drift-status=DRIFTED" >> $GITHUB_OUTPUT
# else
#   echo "drift-status=IN-SYNC" >> $GITHUB_OUTPUT
# fi

exit
