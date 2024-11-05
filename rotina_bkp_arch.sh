#!/usr/bin/env bash

####################################################################################################
# Script Name    : rotina_bkp_arch.sh                                                              #
# Description    : Faz backup do archive no RMAN                                                   #
# Author         : Cristina dos Santos                                                             #
# Email          : chrisreviloutbreak@gmail.com                                                    #
# Execute        : ./rotina_bkp_arch.sh ORACLE_SID  ORACLE_HOME                                    #
####################################################################################################

LOCAL_LOG=/home/oracle/jobs/backup/rman
DATA_BKP=$(date +%d-%m-%Y)

export ORACLE_SID=$1
export ORACLE_BASE=/u01/app/oracle
export ORACLE_HOME=$2
export PATH=$ORACLE_HOME/bin:$PATH

rman target / <<RUNRMAN
spool log to ${LOCAL_LOG}/logs/${ORACLE_SID}_bkp_arch_${DATA_BKP}.log
run
{
allocate channel ch01 device type disk;
allocate channel ch02 device type disk;
allocate channel ch03 device type disk;
allocate channel ch04 device type disk;
backup
  as compressed backupset
  skip inaccessible
  tag BKP_ARCH
  (archivelog all);
delete
  noprompt archivelog all
  backed up 1 times to disk;
backup
  tag backup_ctfile
    (current controlfile);
backup
  tag backup_spfile
   (spfile);
release channel ch01;
release channel ch02;
release channel ch03;
release channel ch04;
}
spool log off
RUNRMAN
