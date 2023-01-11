#!/usr/bin/env bash

#curl -Lso delegated-apnic-latest https://ftp.apnic.net/stats/apnic/delegated-apnic-latest

cat delegated-apnic-latest | grep -E '^apnic\|[A-Z]{2}\|ipv4\|' | grep -v '|CN|' | awk -F'|' '{print $4"/"32-log($5)/log(2)}' | aggregate -q > non-china.txt
