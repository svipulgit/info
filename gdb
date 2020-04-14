a4 rpmbuild Petra
a4 make -p Petra product-nocheck
a4 debuginfo Petra

====================
a4 yum install -y Sand-devel
a4 yum install -y Petra-devel

a4 debuginfo Petra
a4 debuginfo Sand

===== Running breadth test under gdb ====
sudo gdb --args python <testfile>
OR

1. sudo gdb python
2. you will be in gdb. Set the break point here ( you can get the stack trace by
doing a4 debug -b <file with back trace in it >.
3. run <python file>

======= debugging core in python ===
a4 yum install python-debuginfo
or
a4 debuginfo <agentname>

gdb python <corefile>

==== core file ====

EosCoredumpControl SandFap-Linecard3
gdb <processname> --core <corefile>

# For processes started by netnsd
gdb netnsd --core <corefile>

============
Alternately from workspace invoke gdb:
a4 scp dist:/dist/release/il.chicago-rel/final/images/EOS.swi
swi workspace arTradebot EOS.swi( Swi is from dist/release )
swi chroot arTradebot
debuginfo-install SandL3Unicast
< in chrooted swi workspac get memory map from agent log file >
a4 debug -m SandL3Unicast-28793 <core-file>
#### gdb -e ... -c <corefile> command doesn't work in swi workspace
============
Creating swi workspace even after dist repo is gone
swi workspace --noauto -r http://us133/svipul/ws/RPMS/ rgoh3 EOS.swi

---

1) swi chroot <workspace>
2) yum install file < This will install file command which is used by a4 debug >
3) yum install binutils < This will install binutils and install readelf'
4) Install debug info for packages [ e.g. yum install StrataL3-debuginfo ; yum
install Ale-debuginfo ]
5) a4 debug -m <map_file> <core_file>
============

(gdb) exec-file /usr/bin/SandL3Unicast
(gdb) core-file <corefile>
Missing separate debuginfos, use: debuginfo-install
SandL3Unicast-1.0.0-1165652.caberkeleydev.i686

=================
For agents loaded with netnsd
- see below sandtopo example

====== On dut ========
bash-4.1# sudo gdb /usr/bin/netnsd core.25379.1347338710.FocalPoint

[admin@so640 core]$ ps -aef | grep -i FocalPoint
root      4310  1607 12 10:16 ?        00:01:49 FocalPoint      -d -i --dlopen
-p -f  -l libLoadDynamicLibs.so procmgr libProcMgrSetup.so --daemonize

[admin@so640 core]$ sudo ls -l /proc/4310/exe
=================

service ProcMgr stoppm

get your Agent's PID: "bash-4.0# 
ps x | grep AgentName
get your dut's ip address: "nslookup <dutspec>"



At bash

service ProcMgr stoppm
service ProcMgr start
ps -ef | grep SandSlice | grep card
kill Fabric1 SandSlice process

gdbserver :5900 SandSlice --cardType=fe --sliceId=Fabric1
gdbserver :5900 --attach 2778

--

From your workspace:

gdb -e SandSlice 
target extended-remote <dut>:5900
break SandCellAgentFe600.tin:1288 (Just before 'cm = debugSm()->chipMemoryIs')
c

======== connecting remote gdb to namespace dut ==========
You can go into the namespace (e.g., netns waltartrX) and start Acons.
Once you find the pid of the process you like to attach your gdb, then
sudo gdb <binName> <pid>
or
sudo gdb
exec-file <binName>
attach <pid>

==========
gdbinit
==========
set overload-resolution off 
set print static off
set print object

==========
Running gdb on DUT
==========
art scp Petra-debuginfo.i686.rpm tg204:/tmp
sudo rpm -Uvh Petra-debuginfo.i686.rpm
gdb
file SandSlice
b 
run `SandSlice --cardType=fe --sliceId=Fabric1`
OR
run --cardType=fe --sliceId=Fabric1

Alternate
=========
art update
sudo rpm -Uvh (may not need, art update takes care of it)

bash-4.1# ps x | grep SandTopo
14794 ?        S      0:00 netns --dlopen procmgr /usr/bin/SandTopo
14796 ?        S      0:01 SandTopo        -d -i --dlopen -p -f  -l libLoadDynamicLibs.so procmg
gdb -e SandTopo

attach 14796


==========
Copying gdb-server to DUT (not needed).
==============
a4 yumdownloader --enablerepo=* gdb-gdbserver

art scp gdb-gdbserver-7.2-52.fc14.i686.rpm tg204:/tmp
rpm -i ....rpm





=========
Loading library in gdb - doesn't work
========
gdb python
import Tac
>>> Tac.dlopen( 'libSandCellLoader.so' )
136887536
>>> d = Tac.dlopen( 'libSandCellLoader.so' )
>>> d.call( 'main', 0, 0 )

>>> import dl
>>> d = dl.open( 'libSandCellLoader.so' )
>>> d.call( 'main', 0, 0 )



============== Debugging SandFap ============
strataApi.o:
       CFLAGS="-g2 -O0 -Wall -DLKM_2_6" TARGET=unix-user $(MAKE) -j 1 -C sdk
       this is in StrataApi/Makefile.am
sudo gdb
exec-file SandFap
attach <pid>
/tmp/... file creation.


======= Misc gdb command ====
info thread
thread apply all bt  - backtrace for all threads

================ loading shared library symbol into gdb ====
a4 debug <corefile> -m Rib-1687
...
(gdb) info symbol 0xee2a4a36

=============== for stest Rib agent core ==========
sudo gdb Rib -c <corefile>

==========
print type of structue
print &fdbEntry

==========
print type of structue
breaking into gdb with function call
#include signal.h
raise( SIGTRAP );

OR
asm volatile ( "int $3;" );
==========
info proc mappings
info proc cmdline
info proc exe
==========

(gdb) info reg
ebp            0xffdf19b8       0xffdf19b8

(gdb) x/x 0xffdf19b8
0xffdf19b8:     0xffdf2228
(gdb)
0xffdf19bc:     0x081cbfab
(gdb) x/i 0x081cbfab
   0x81cbfab <bgp_ecmp_nhelist_find+699>:       mov    -0x81c(%ebp),%edx

   if (bmvalid && !ucmp) {
      nhelistp = nhelist_find(n_ecmp, max_paths, max_ecmp_sz,
               config_options, max_ucmp, &bgp_nhes[0],
               bm);

(gdb) x/x 0xffdf19b8
0xffdf19b8:     0xffdf2228
(gdb)
0xffdf19bc:     0x081cbfab
(gdb)
0xffdf19c0:     0x00000004
(gdb)
0xffdf19c4:     0x00000080
(gdb)
0xffdf19c8:     0x00000080
(gdb)
0xffdf19cc:     0x00000000
(gdb)
0xffdf19d0:     0x00000000
(gdb)
0xffdf19d4:     0xffdf1a10
(gdb)
0xffdf19d8:     0xe9ba25c4
(gdb) p *(nhelist_bitmap *)0xe9ba25c4
$4 = {
  bm = {0xdb399ff4 "", 0x0},
  bitset = {4, 0},
  bmsize = {6, 0},
  hashmix = 1748799741
}
(gdb)

======
# Attaching to Bgp process in bgprtr namespace dut
function bgpAttach() {
        pid=`cat /tmp/ArosTest/$NSPATH/bgprtr1.txt | grep ^Bgp | awk '{ print $3 }'`
        if [ x"$pid" != x"" ]; then
          sudo gdb -e `readlink -f /usr/bin/Bgp` --pid=$pid
        fi
}
sudo gdb -e Bgp -c /var/core/core.8838.1494900343.Bgp
======
You can use "set auto-solib-add off" to cut back on what gdb is loading.

That is:
gdb python
(gdb) set auto-solib-add off
(gdb) core-file core.5050.1487803782.python

Now your backtrace will be very boring but you should be able to figure out what libraries you want. You can load them with the "sharedlibrary" command.
======
sudo gdb --batch -e /usr/bin/Ebra -p $(pidof -s Ebra)  -ex 'set print elements 0' -ex 'x/s getenv( "TRACE" )'
======
Accessing rawPtr
(gdb) print notifyingPathListToRkp_
$6 = (Routing::Bgp::RkPartitionThread::TacNotifyingPathListToRkp)0x8eaf040 (SmartPtr)

(gdb) print notifyingPathListToRkp_.rawPtr_
$7 = (Routing::Bgp::RkPartitionThread::TacNotifyingPathListToRkp *) 0x8eaf040

(gdb) print notifyingPathListToRkp_.rawPtr_.rkPartitionThread_
$9 = (Routing::Bgp::RkPartitionThread *) 0x8eaef10

(gdb) p this->notifyingPathHolder_.rawPtr_
$10 = (Routing::Bgp::RkPartitionThread::TacNotifyingPathHolder *)0x55ec4b376880
(gdb) p *$10
$11 = (Routing::Bgp::RkPartitionThread::TacNotifyingPathHolder) {
      notifier_ = (Tac::PtrInterface)0x55ec4b386850 (SmartPtr) ,
    }, <No data fields>},
  members of Routing::Bgp::RkPartitionThread::TacNotifyingPathHolder:
  rkPartitionThread_ = (Routing::Bgp::RkPartitionThread *)0x55ec4bad0da0
}

(gdb) p *( 'Routing::Bgp::NotifyingPathHolder' *) $10->notifier_
$12 = (Routing::Bgp::NotifyingPathHolder) {
  <Tac::PtrInterface> = ref:536870919,
  members of Routing::Bgp::NotifyingPathHolder:
  notifyingPath_ = {
    pathKey_ = (Routing::Bgp::PathKey const)0x0 (SmartPtr),
    path_ = (Routing::Bgp::AdjRibinPath const)0x0 (SmartPtr)
  },
  notifiee_ = NotifieeList[], members:1 = {(Routing::Bgp::RkPartitionThread::TacNotifyingPathHolder *)0x55ec4b376880}
}

======
# Read partial core file
gzip -c -d core.17095.1528760409.Bgp-main.partial.gz > tmpcore
readelf -l tmpcore
======
(gdb) call sym_get_name( bgpi()->default_maintenance_receiver_rm->adv_list->adv_syment )
.MAINTENANCE-RECEIVER
======
(gdb) add-symbol-file /usr/lib/libIpRibLib.so 0
add symbol table from file "/usr/lib/libIpRibLib.so" at
        .text_addr = 0x0
(y or n) y
Reading symbols from /usr/lib/libIpRibLib.so...Reading symbols from /usr/lib/debug/usr/lib/libIpRibLib.so.0.0.0.debug...done.
(gdb) sym Bgp
Load new symbol table from "Bgp"? (y or n) y
Reading symbols from Bgp...Load new symbol table from "/usr/lib/debug/usr/bin/Bgp.debug"? (y or n) y
Reading symbols from /usr/lib/debug/usr/bin/Bgp.debug...done.
(gdb) p sizeof(Routing::Rib::RouteKey)
$1 = 28
(gdb) p/d offsetof( Routing::Rib::Route, routingProtocol_)
$3 = 28
======
======
======
