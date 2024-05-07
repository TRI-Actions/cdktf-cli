#!/bin/bash
pipenv install
cd $1
cdktf deploy --auto-approve --no-color > deploy.out
