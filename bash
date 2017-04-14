#/usr/bin/bash
bash while(:) do echo $(date); arp | grep 1.253; sleep 1 ; done 
bash while [ 1 ]; do date; ip neigh show nud all ; sleep 1; echo =======; done
ip route show table local
iptables -nvL

monitor kernel v6 neighbors
ip −6 monitor neigh
sudo ip netns exec ns-30 ip -6 neigh

#bash
for i in {1..1000};
   do
      echo Iteration $i;
      /usr/bin/fab dump | grep "rx ring" | grep "\.R"
      sleep 0.5s;
   done

======
print timestamp for ip monitor command
======
import subprocess, shlex, datetime, sys

cmd = "ip -6 monitor neigh"
args = shlex.split(cmd)
process = subprocess.Popen(
    args, stdout=subprocess.PIPE, stderr=subprocess.PIPE )

while True:
    out = process.stdout.read(1)
    if out == '' and process.poll() != None:
        break
    if out != '':
        sys.stdout.write( out )
        if out == "\n":
            sys.stdout.write( "%s\n\n   " % datetime.datetime.utcnow() )
        sys.stdout.flush()
=====
#Kill an agent if RSS mem usage goes about certain limit
#!/bin/bash

# Set limit as 1.2G
MEMLIMIT=${1:-1200000}
echo "MEMLIMIT: $MEMLIMIT" >> /tmp/memcheck.out
while :; do
    MemUsage SandL3Unicast > /tmp/memusage.out
    date >> /tmp/memcheck.out
    egrep "size:|rss:|sbrk" /tmp/memusage.out
    RSS=`awk '/rss:/ { print $2/1024 }' /tmp/memusage.out`
    if test $RSS -gt $MEMLIMIT; then
        echo "===== SandL3Unicast memory exceeded limit ====="  >> /tmp/memcheck.out
        sudo kill `pgrep SandL3Unicast`
    fi 
    sleep 60
done
====
netns etba43 (To run Acons)
ip addr ... dev etba43-et1 (assign ip addre to kernel intf)
====
kernel packet stats:
bash netstat -lw | grep igmp
====

# Bug query
a4 bugs -b fl.l3scale-triage -b fl.l3scale-looking | egrep -v '(93056|93058)' | grep -v "Total bugs" | grep -v "Total work" | awk '{ split($4, b, "/"); print b[1]; }' | sort -k1 | uniq -c | sort -k1 -g | awk '{ print "     " $1 " " $2; sum = sum + $1} END { print "\n Total Bug Count " sum "\n"}'

=======
Check kernel ipv4 forwarding state:
cat /proc/sys/net/ipv4/conf/et2_2/forwarding
sudo sh -c "echo 1 > /proc/sys/net/ipv4/conf/et2_2/forwarding"
=======
