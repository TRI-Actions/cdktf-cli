#!/bin/bash
export CI=1

for i in $WORKDIRS; do
  cd $i
  echo Running plan for $i
  cdktf diff --refresh-only --no-color > plan.out

  INDEX=$(awk '/Note: Objects have changed/{ print NR; exit }' plan.out)

  if [[ $INDEX ]]; then
    echo Drift Detected!
    sed -i "1,$((INDEX-1)) d" plan.out
    echo "drift-status=DRIFTED" >> $GITHUB_OUTPUT
  else
    echo No drift detected!
    echo "drift-status=IN-SYNC" >> $GITHUB_OUTPUT
    cdktf diff --no-color > plan.out
  fi
  cd ..
done

echo Done!

exit
