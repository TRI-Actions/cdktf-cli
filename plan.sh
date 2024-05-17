#!/bin/bash
export CI=1

for i in $WORKDIRS; do
  if [ ! -d $i ]; then
    echo $i is not a directory, skipping..
    continue
  fi
  cd $i
  echo Running plan for $i

  cdktf diff $options > plan.out

  INDEX=$(awk '/Note: Objects have changed/{ print NR; exit }' plan.out)

  if [[ -n "$INDEX" ]]; then
    echo Drift Detected!
    sed -i "1,$((INDEX-1)) d" plan.out
    echo "DRIFTED" > drift.out
  else
    echo No drift detected!
    echo "IN-SYNC" > drift.out
    cdktf diff --no-color > plan.out
  fi
  if [ ! $i == '.' ]; then
    cd ..
  fi
done

echo Done!

exit
