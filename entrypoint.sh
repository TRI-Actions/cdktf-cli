#!/bin/bash

export CI=1

cd $GITHUB_WORKSPACE
pipenv install
cd $INPUT_WORKDIR
if [ "$INPUT_ACTION" = "plan" ]; then
  cdktf diff --refresh-only --no-color > plan.out
elif [ "$INPUT_ACTION" = "deploy" ]; then
  cdktf deploy --auto-approve --no-color > deploy.out
fi
