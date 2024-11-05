#!/usr/bin/env bash

####################################################################################################
# Script Name    : rotina_bkp_incremental_lv0.sh                                                   #
# Description    : Faz backup incremental level 0                                                  #
# Author         : Cristina dos Santos                                                             #
# Email          : chrisreviloutbreak@gmail.com                                                    #
# Execute        : ./rotina_bkp_incremental_lv0.sh ORACLE_SID  ORACLE_HOME                         #
####################################################################################################

LOCAL_LOG=/home/oracle/jobs/backup/rman
DATA_BKP=$(date +%d-%m-%Y)

export ORACLE_SID=$1
export ORACLE_BASE=/u01/app/oracle
export ORACLE_HOME=$2
export PATH=$ORACLE_HOME/bin:$PATH

rman target / <<RUNRMAN
spool log to $LOCAL_LOG/logs/${ORACLE_SID}_incremental_lv0_${DATA_BKP}.log
run
{
backup
  as compressed backupset
  incremental level 0
  skip inaccessible
  tag BKP_INCR_N0
  database plus archivelog;
delete
	noprompt archivelog all
	backed up 1 times to disk;
backup
  tag backup_ctfile
    (current controlfile);
backup
  tag backup_spfile
   (spfile);
}
spool log off
RUNRMAN
