.PHONY: all

all: china-list.txt netflix-aws.txt non-china-list.txt

delegated-apnic-latest:
	curl -Lo "$@" https://ftp.apnic.net/stats/apnic/delegated-apnic-latest

ipv4-address-space.csv:
	curl -Lo "$@" https://www.iana.org/assignments/ipv4-address-space/ipv4-address-space.csv

GeoLite2-Country.zip:
	curl -Lo "$@" "https://download.maxmind.com/app/geoip_download?edition_id=GeoLite2-Country-CSV&license_key=$(GEOIP_LICENSE)&suffix=zip"

GeoLite2-Country-Blocks-IPv4.csv: GeoLite2-Country.zip
	unzip -o -j "$<" "*/$@"
	touch "$@"

china-list.txt: GeoLite2-Country-Blocks-IPv4.csv
	cat "$<" | grep ',1814991,' | awk -F',' '{print $$1}' > "$@"

aws.json:
	curl -Lo "$@" 'https://ip-ranges.amazonaws.com/ip-ranges.json'

netflix.txt:
	echo -n "" > "$@.progress"
	for as in 55095 40027 394406 2906 136292; do \
  	whois -h whois.radb.net -- '-i origin AS'$$as | grep -Eo '([0-9.]+){4}/[0-9]+' >> "$@.progress" ;\
	done
	cat "$@.progress" | aggregate -q > "$@"
	rm -f "$@.progress"

netflix-aws.txt: aws.json netflix.txt
	cp -f netflix.txt "$@.progress"
	jq -r '[.prefixes[] | select(.service=="AMAZON" and (.region | startswith("us-"))).ip_prefix] | .[]' < aws.json >> "$@.progress"
	cat "$@.progress" | grep -v '^$$' | aggregate -q > "$@"
	rm -f "$@.progress"

non-china-list.txt: china-list.txt ipv4-address-space.csv
	python nchnroutes.py --ipv4-list ipip
	cat routes4.conf | aggregate -q > "$@"
	rm -f routes4.conf

