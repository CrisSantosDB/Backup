#!/usr/bin/env bash

####################################################################################################
# Script Name    : rotina_bkp_crosscheck.sh                                                        #
# Description    : Faz crosscheck dos backup no RMAN, deleta bkp expired e obsolete                #
# Author         : Cristina dos Santos                                                             #
# Email          : chrisreviloutbreak@gmail.com                                                    #
# Execute        : ./rotina_bkp_crosscheck.sh ORACLE_SID  ORACLE_HOME                              #
####################################################################################################

LOCAL_LOG=/home/oracle/jobs/backup/rman
DATA_BKP=$(date +%d-%m-%Y)

export ORACLE_SID=$1
export ORACLE_BASE=/u01/app/oracle
export ORACLE_HOME=$2
export PATH=$ORACLE_HOME/bin:$PATH

rman target / <<RUNRMAN
spool log to $LOCAL_LOG/logs/${ORACLE_SID}_crosscheck_${DATA_BKP}.log
run
{
  crosscheck backup;
  crosscheck archivelog all;
  delete noprompt expired backup;
  delete noprompt expired archivelog all;
  delete noprompt obsolete;
  report need backup;
}
spool log off
RUNRMAN
