#!/usr/bin/env bash

echo "# Useful CIDRs

| File | CIDRs | Last Updated |
| - | - | - |"
git ls-files -- '*.txt' | while read line; do
  count=$(cat "$line" | grep -v "^$" | grep -v '^#' | wc -l | awk '{printf "%'"'"'d", $1}')
  updated=$(git log -1 --pretty="format:%ci" -- "$line")
  echo "| [$line](https://gist.githubusercontent.com/xc2/10775fab2ad1edad0ad31e0b80774180/raw/${line}) | $count | $updated |"
done