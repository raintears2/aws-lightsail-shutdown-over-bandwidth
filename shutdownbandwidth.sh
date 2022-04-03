[ $1 ] && insname=$1 || exit

[ $3 ] && region=$3 

[ $2 ] && ip=$2 


echo $ip |grep -Po '^([0-9]{1,3}.?){4}$' ||  ip=$(aws --region $region lightsail get-instance  --instance-name $insname |jq .instance.publicIpAddress|xargs)


 
 networkout=$(aws lightsail get-instance-metric-data \
      --region $region \
      --instance-name $insname \
      --metric-name NetworkOut \
      --period 2628000 \
      --start-time $(date -d  "$(date +%Y-%m)-01" +%s) \
      --end-time $(date +%s) \
      --unit Bytes \
      --statistics Sum \
      |jq  .metricData[].sum)
      
      

  networkin=$(aws lightsail get-instance-metric-data \
      --region $region \
      --instance-name $insname \
      --metric-name NetworkIn \
      --period 2628000 \
      --start-time $(date -d  "$(date +%Y-%m)-01" +%s) \
      --end-time $(date +%s) \
      --unit Bytes \
      --statistics Sum \
      |jq  .metricData[].sum)




networksum=$[networkout+networkin]

echo $(date +%Y%m%d-%H%M%S) $0: instance $insname $ip from $(date +%Y-%m)-01 to now $(echo "scale=4;$networksum /1024 /1024 /1024  " |bc) GB 

all900GB=966367641600

[ $networksum -gt $all900GB ] && echo "$(date +%Y%m%d-%H%M%S) $0: stop instance $insname $ip over 900GB" && aws --region $region lightsail stop-instance  --instance-name $insname  
