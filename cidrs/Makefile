.PHONY: all

all: china-list.txt netflix-aws.txt non-china-list.txt netflix-aws-us-west-2.txt valve.txt zscaler.txt

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
	for as in 55095 40027 2906; do \
  	whois -h whois.radb.net -- '-i origin AS'$$as | grep -Eo '([0-9.]+){4}/[0-9]+' >> "$@.progress" ;\
	done
	# Netflix Stream Services :: HiNet Peering
	echo "203.75.0.0/16" >> "$@.progress"
	cat "$@.progress" | aggregate -q > "$@"
	rm -f "$@.progress"

netflix-aws.txt: aws.json netflix.txt
	cp -f netflix.txt "$@.progress"
	jq -r '[.prefixes[] | select(.service=="EC2" and (.region | in({"us-west-2":1,"us-east-1":1,"eu-west-1":1}))).ip_prefix] | .[]' < aws.json >> "$@.progress"
	cat "$@.progress" | grep -v '^$$' | aggregate -q > "$@"
	rm -f "$@.progress"

netflix-aws-us-west-2.txt: aws.json netflix.txt
	cp -f netflix.txt "$@.progress"
	jq -r '[.prefixes[] | select(.service=="EC2" and (.region | in({"us-west-2":1}))).ip_prefix] | .[]' < aws.json >> "$@.progress"
	cat "$@.progress" | grep -v '^$$' | aggregate -q > "$@"
	rm -f "$@.progress"

non-china-list.txt: china-list.txt ipv4-address-space.csv delegated-apnic-latest
	python nchnroutes.py --ipv4-list ipip
	cat routes4.conf | aggregate -q > "$@"
	rm -f routes4.conf

valve.txt:
	whois -h whois.radb.net -- '-i origin AS32590' | grep -E '^route:' | awk '{print $$2}' | aggregate -q > "$@"


zscaler.txt:
	rm -f "$@.progress"
	for as in 62907 62044 53813 53444 22616; do \
  	whois -h whois.radb.net -- '-i origin AS'$$as | grep -Eo '([0-9.]+){4}/[0-9]+' >> "$@.progress" ;\
	done
	cat "$@.progress" | aggregate -q > "$@"
	rm -f "$@.progress"