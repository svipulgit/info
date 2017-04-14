====================
mysql -u arastra -h mutdb -e "select * from mutdb.mut where name = 'svipul.arbt.0'\G;"
====================
Find out  the user who schedule ptests or stests against a project 
====================
a4 ssh mysql
~ @mysql-a1> mysql
localhost> select distinct project from Arjob.job where type = 'autotest' and owner='ANY' limit 80 ;
localhost> select * from Arjob.job where type = 'autotest' and project = 'co.golden' and owner = 'svipul' limit 10;

Restore rdam database
====================

a4 ssh mysql
cd /var/lib/mysql
zcat mysql-dump-09AM.gz | sed -n -e '/^-- Current Database: `rdam`/,/^-- CurrentDatabase/p' > /tmp/rdam.mysql
mysql rdam < /tmp/rdam.mysql


SQL database
====================

ap abuild
a4 ssh mysql
~ @mysql> mysql
mysql> use Abuild
mysql> describe abuildStats;
mysql> select * from abuildStats where <qualifiers>;
*make sure it looks like the rows you want*
mysql> update abuildStats set <column values to change> where <qualifiers>;

mysql> select count(*) from scheduledTests where priority > 75 limit 10;
See here for info on update syntax: http://www.w3schools.com/sql/sql_update.asp

