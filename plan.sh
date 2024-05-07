#!/bin/bash
pipenv install
cd $1
cdktf diff --refresh-only --no-color > plan.out
