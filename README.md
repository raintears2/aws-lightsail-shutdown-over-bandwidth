# aws-lightsail-shutdown-over-bandwidth
use aws cli to check instances in all regions bandwidth and shutdown when over 900GB from every month 1st to current time.

Install:

1.Download the script file to /root/

2.echo "*/15 * * * * /root/checkbandwidth.sh" >> /var/spool/cron/root
