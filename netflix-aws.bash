#!/usr/bin/env bash
echo > cidr.txt
for as in 55095 40027 394406 2906 136292; do
  whois -h whois.radb.net -- '-i origin AS'$as | grep -Eo '([0-9.]+){4}/[0-9]+' >> cidr.txt
done
wget https://ip-ranges.amazonaws.com/ip-ranges.json
jq -r '[.prefixes[] | select(.service=="AMAZON" and (.region | startswith("us-"))).ip_prefix] | .[]' < ip-ranges.json >> cidr.txt
cat cidr.txt | grep -v '^$' | aggregate -q > netflix-aws.txt

rm -f ip-ranges.json cidr.txt
