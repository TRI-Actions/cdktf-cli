#!/bin/bash
export CI=1

for i in $WORKDIRS; do
  cd $i
  echo Destroying $i
  cdktf destroy --auto-approve --no-color > destroy.out
  cd ..
done

exit
