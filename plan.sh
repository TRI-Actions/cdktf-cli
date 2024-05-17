#!/bin/bash
export CI=1

plan() {
  dir=$1
  cd dir
  echo Running plan for $dir
  options=" --no-color"
  if [ "$DRIFT_CHECK" == "true" ]; then
    options+=" --refresh-only"

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
  else
    cdktf diff $options > plan.out
  fi
}

for i in $WORKDIRS; do
  if [ ! -d $i ]; then
    echo $i is not a directory, skipping..
    continue
  fi
  plan $i &
done

wait
echo Done!

exit
