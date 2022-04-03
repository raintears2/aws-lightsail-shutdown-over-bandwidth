#!/bin/bash
source /etc/profile
PATH=/usr/sbin:/usr/local/bin:$PATH
aws lightsail get-regions|jq .regions[].name|xargs -i aws lightsail --region {} get-instances |jq .instances[]|jq -r '"\(.name) \(.publicIpAddress) \(.location.regionName)"' |xargs -i -P 10 sh -c "sh shutdownbandwidth.sh {}"
