#!/bin/bash

for d in $NOTES/*; do cd "$d" && ct-git-sync; done
