#!/bin/bash
cd $1
cdktf diff --refresh-only --no-color > plan.out
