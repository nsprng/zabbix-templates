#!/bin/bash


#########################################################
#							#
# IBM Storwize v3700 DataStore monitoring		#
# 							#
# Usage: IBM_v3700.sh <IP> <USER> <PSWD> <PARAM> <DATA> #
# Options:						#
#         $1 V3700 IP address				#
#         $2 user					#
#         $3 password					#
#         $4 parameter to inspect			#
#         $5 data for the parameter			#
#							#
#########################################################


if [ $# -lt 4 ]; then
  echo "ERROR: Not enough parameters"
  echo "Usage: $0 <IP> <USER> <PSWD> <Parameter> <Data for the parameter>"
  cat << EOF
"Parameters: lsdrive, lsarray, lsvdisk, lsenclosure, lsenclosurebattery,
	     lsenclosurecanister, lsenclosurepsu, lsquorum, lsmdiskgrp,
	     lsenclosurepower, lsenclosuretemp, lsstat_cpu_comp,
	     lsstat_cpu_pc, lsstat_fc_mb, lsstat_fc_io, lsstat_sas_mb,
	     lsstat_sas_io, lsstat_iscsi_mb, lsstat_iscsi_io,
	     lsstat_write_cache, lsstat_total_cache, lsstat_vdisk_mb,
	     lsstat_vdisk_io, lsstat_vdisk_ms, lsstat_mdisk_mb,
	     lsstat_mdisk_io, lsstat_mdisk_ms, lsstat_drive_mb,
	     lsstat_drive_io, lsstat_drive_ms, lsstat_vdisk_w_mb,
	     lsstat_vdisk_w_io, lsstat_vdisk_w_ms, lsstat_mdisk_w_mb,
	     lsstat_mdisk_w_io, lsstat_mdisk_w_ms, lsstat_drive_w_mb,
	     lsstat_drive_w_io, lsstat_drive_w_ms, lsstat_vdisk_r_mb,
	     lsstat_vdisk_r_io, lsstat_vdisk_r_ms, lsstat_mdisk_r_mb,
	     lsstat_mdisk_r_io, lsstat_mdisk_r_ms, lsstat_drive_r_mb,
	     lsstat_drive_r_io, lsstat_drive_r_ms, lsstat_iplink_mb,
	     lsstat_iplink_io"
EOF
  exit 2
fi


# lsdrive -> Status of drives
if [[ $4 == 'lsdrive' ]]; then
  ENC_ID=$5
  DRV_ID=$6 
  RESULT=$(sshpass -p $3 ssh -o StrictHostKeyChecking=no $2@$1 '( lsdrive)' )
  if [ -z $(echo "$RESULT" |awk '$9=='"$ENC_ID"' && $10=='"$DRV_ID"' {print $2}') ]; then
    echo "$RESULT" |awk '$6=='"$ENC_ID"' && $7=='"$DRV_ID"' {print $2}'
  else
    echo "$RESULT" |awk '$9=='"$ENC_ID"' && $10=='"$DRV_ID"' {print $2}' 
  fi
fi

# lsarray -> Status of MDisks
if [[ $4 == 'lsarray' ]]; then
  ARR_ID=$5 
  RESULT=$(sshpass -p $3 ssh -o StrictHostKeyChecking=no $2@$1 '( lsarray )' )
  if [ -z "$6" ]; then
    echo "$RESULT" |awk '$1=='"$ARR_ID"' {print $3}'
  else
    #get array name
    if [[ $6 == 'name' ]]; then
      echo "$RESULT" |awk '$1=='"$ARR_ID"' {print $5}'
    fi
  fi
fi

# lsvdisk -> Status of volumes(LUN's/vdisk's)
if [[ $4 == 'lsvdisk' ]]; then
  VOL_ID=$5 
  RESULT=$(sshpass -p $3 ssh -o StrictHostKeyChecking=no $2@$1 '( lsvdisk )' )
  if [ -z "$6" ]; then
    echo "$RESULT" |awk '$1=='"$VOL_ID"' {print $5}'
  else
    #get volume name
    if [[ $6 == 'name' ]]; then
      echo "$RESULT" |awk '$1=='"$VOL_ID"' {print $2}'
    fi
  fi
fi

# lsenclosure -> Status of enclosures
if [[ $4 == 'lsenclosure' ]]; then
  ENC_ID=$5 
  RESULT=$(sshpass -p $3 ssh -o StrictHostKeyChecking=no $2@$1 '( lsenclosure )' )
  echo "$RESULT" |awk '$1=='"$ENC_ID"' {print $2}'
fi

# lsenclosurebattery -> Status of batteries in PSU
if [[ $4 == 'lsenclosurebattery' ]]; then
  ENC_ID=$5
  BAT_ID=$6
  RESULT=$(sshpass -p $3 ssh -o StrictHostKeyChecking=no $2@$1 '( lsenclosurebattery )' )
  echo "$RESULT" |awk '$1=='"$ENC_ID"' && $2=='"$BAT_ID"' {print $3}'
fi

# lsenclosurecanister -> Status of canister/nodes
if [[ $4 == 'lsenclosurecanister' ]]; then
  ENC_ID=$5
  CAN_ID=$6
  RESULT=$(sshpass -p $3 ssh -o StrictHostKeyChecking=no $2@$1 '( lsenclosurecanister )' )
  echo "$RESULT" |awk '$1=='"$ENC_ID"' && $2=='"$CAN_ID"' {print $3}'
fi

# lsenclosurepsu -> Status of PSU's
if [[ $4 == 'lsenclosurepsu' ]]; then
  ENC_ID=$5 
  PSU_ID=$6
  RESULT=$(sshpass -p $3 ssh -o StrictHostKeyChecking=no $2@$1 '( lsenclosurepsu )' )
  echo "$RESULT" |awk '$1=='"$ENC_ID"' && $2=='"$PSU_ID"' {print $3}'
fi

# lsquorum -> Status of MDisks used to store quorum data
if [[ $4 == 'lsquorum' ]]; then
  Q_ID=$5
  RESULT=$(sshpass -p $3 ssh -o StrictHostKeyChecking=no $2@$1 '( lsquorum )' )
  echo "$RESULT" |awk '$1=='"$Q_ID"' {print $2}'
fi

# lsmdiskgrp -> Status of Pools
if [[ $4 == 'lsmdiskgrp' ]]; then
  POOL_ID=$5
  RESULT=$(sshpass -p $3 ssh -o StrictHostKeyChecking=no $2@$1 '( lsmdiskgrp )' )
  if [ -z "$6" ]; then
    echo "$RESULT" |awk '$1=='"$POOL_ID"' {print $3}'
  else
    #get pool name
    if [[ $6 == 'name' ]]; then
      echo "$RESULT" |awk '$1=='"$POOL_ID"' {print $2}'
    fi
  fi
fi

# lsenclosurepower -> Enclosure system power, Watts
if [[ $4 == 'lsenclosurepower' ]]; then
  ENC_ID=$5
  RESULT=$(sshpass -p $3 ssh -o StrictHostKeyChecking=no $2@$1 '( lsenclosurestats )' )
  echo "$RESULT" |awk '$1=='"$ENC_ID"' && $2=="power_w" {print $3}'
fi

# lsenclosuretemp -> Enclosure system power, degrees C
if [[ $4 == 'lsenclosuretemp' ]]; then
  ENC_ID=$5
  RESULT=$(sshpass -p $3 ssh -o StrictHostKeyChecking=no $2@$1 '( lsenclosurestats )' )
  echo "$RESULT" |awk '$1=='"$ENC_ID"' && $2=="temp_c" {print $3}'
fi

# lsstat_cpu_comp -> CPU utilized for compression, %
if [[ $4 == 'lsstat_cpu_comp' ]]; then
  NODE_ID=$5
  RESULT=$(sshpass -p $3 ssh -o StrictHostKeyChecking=no $2@$1 '( lsnodecanisterstats )' )
  echo "$RESULT" |awk '$1=='"$NODE_ID"' && $3=="compression_cpu_pc" {print $4}'
fi

# lsstat_cpu_pc -> CPU utilized for the system, %
if [[ $4 == 'lsstat_cpu_pc' ]]; then
  NODE_ID=$5
  RESULT=$(sshpass -p $3 ssh -o StrictHostKeyChecking=no $2@$1 '( lsnodecanisterstats )' )
  echo "$RESULT" |awk '$1=='"$NODE_ID"' && $3=="cpu_pc" {print $4}'
fi

# lsstat_fc_mb -> FC traffic, MBps
if [[ $4 == 'lsstat_fc_mb' ]]; then
  NODE_ID=$5
  RESULT=$(sshpass -p $3 ssh -o StrictHostKeyChecking=no $2@$1 '( lsnodecanisterstats )' )
  echo "$RESULT" |awk '$1=='"$NODE_ID"' && $3=="fc_mb" {print $4}'
fi

# lsstat_fc_io -> FC traffic, IOPS
if [[ $4 == 'lsstat_fc_io' ]]; then
  NODE_ID=$5
  RESULT=$(sshpass -p $3 ssh -o StrictHostKeyChecking=no $2@$1 '( lsnodecanisterstats )' )
  echo "$RESULT" |awk '$1=='"$NODE_ID"' && $3=="fc_io" {print $4}'
fi

# lsstat_sas_mb -> SAS traffic, MBps
if [[ $4 == 'lsstat_sas_mb' ]]; then
  NODE_ID=$5
  RESULT=$(sshpass -p $3 ssh -o StrictHostKeyChecking=no $2@$1 '( lsnodecanisterstats )' )
  echo "$RESULT" |awk '$1=='"$NODE_ID"' && $3=="sas_mb" {print $4}'
fi

# lsstat_sas_io -> SAS traffic, IOPS
if [[ $4 == 'lsstat_sas_io' ]]; then
  NODE_ID=$5
  RESULT=$(sshpass -p $3 ssh -o StrictHostKeyChecking=no $2@$1 '( lsnodecanisterstats )' )
  echo "$RESULT" |awk '$1=='"$NODE_ID"' && $3=="sas_io" {print $4}'
fi

# lsstat_iscsi_mb -> iSCSI traffic, MBps
if [[ $4 == 'lsstat_iscsi_mb' ]]; then
  NODE_ID=$5
  RESULT=$(sshpass -p $3 ssh -o StrictHostKeyChecking=no $2@$1 '( lsnodecanisterstats )' )
  echo "$RESULT" |awk '$1=='"$NODE_ID"' && $3=="iscsi_mb" {print $4}'
fi

# lsstat_iscsi_io -> iSCSI traffic, IOPS
if [[ $4 == 'lsstat_iscsi_io' ]]; then
  NODE_ID=$5
  RESULT=$(sshpass -p $3 ssh -o StrictHostKeyChecking=no $2@$1 '( lsnodecanisterstats )' )
  echo "$RESULT" |awk '$1=='"$NODE_ID"' && $3=="iscsi_io" {print $4}'
fi

# lsstat_write_cache -> write cache usage, %
if [[ $4 == 'lsstat_write_cache' ]]; then
  NODE_ID=$5
  RESULT=$(sshpass -p $3 ssh -o StrictHostKeyChecking=no $2@$1 '( lsnodecanisterstats )' )
  echo "$RESULT" |awk '$1=='"$NODE_ID"' && $3=="write_cache_pc" {print $4}'
fi

# lsstat_total_cache -> total cache usage, %
if [[ $4 == 'lsstat_total_cache' ]]; then
  NODE_ID=$5
  RESULT=$(sshpass -p $3 ssh -o StrictHostKeyChecking=no $2@$1 '( lsnodecanisterstats )' )
  echo "$RESULT" |awk '$1=='"$NODE_ID"' && $3=="total_cache_pc" {print $4}'
fi

# lsstat_vdisk_mb -> average volumes I/O ops, MBps
if [[ $4 == 'lsstat_vdisk_mb' ]]; then
  NODE_ID=$5
  RESULT=$(sshpass -p $3 ssh -o StrictHostKeyChecking=no $2@$1 '( lsnodecanisterstats )' )
  echo "$RESULT" |awk '$1=='"$NODE_ID"' && $3=="vdisk_mb" {print $4}'
fi

# lsstat_vdisk_io -> average volumes I/O ops, IOPS
if [[ $4 == 'lsstat_vdisk_io' ]]; then
  NODE_ID=$5
  RESULT=$(sshpass -p $3 ssh -o StrictHostKeyChecking=no $2@$1 '( lsnodecanisterstats )' )
  echo "$RESULT" |awk '$1=='"$NODE_ID"' && $3=="vdisk_io" {print $4}'
fi

# lsstat_vdisk_ms -> average volumes I/O ops latency, ms
if [[ $4 == 'lsstat_vdisk_ms' ]]; then
  NODE_ID=$5
  RESULT=$(sshpass -p $3 ssh -o StrictHostKeyChecking=no $2@$1 '( lsnodecanisterstats )' )
  echo "$RESULT" |awk '$1=='"$NODE_ID"' && $3=="vdisk_ms" {print $4}'
fi

# lsstat_mdisk_mb -> average MDisks I/O ops, MBps
if [[ $4 == 'lsstat_mdisk_mb' ]]; then
  NODE_ID=$5
  RESULT=$(sshpass -p $3 ssh -o StrictHostKeyChecking=no $2@$1 '( lsnodecanisterstats )' )
  echo "$RESULT" |awk '$1=='"$NODE_ID"' && $3=="mdisk_mb" {print $4}'
fi

# lsstat_mdisk_io -> average MDisks I/O ops, IOPS
if [[ $4 == 'lsstat_mdisk_io' ]]; then
  NODE_ID=$5
  RESULT=$(sshpass -p $3 ssh -o StrictHostKeyChecking=no $2@$1 '( lsnodecanisterstats )' )
  echo "$RESULT" |awk '$1=='"$NODE_ID"' && $3=="mdisk_io" {print $4}'
fi

# lsstat_mdisk_ms -> average MDisks I/O ops latency, ms
if [[ $4 == 'lsstat_mdisk_ms' ]]; then
  NODE_ID=$5
  RESULT=$(sshpass -p $3 ssh -o StrictHostKeyChecking=no $2@$1 '( lsnodecanisterstats )' )
  echo "$RESULT" |awk '$1=='"$NODE_ID"' && $3=="mdisk_ms" {print $4}'
fi

# lsstat_drive_mb -> average drives I/O ops, MBps
if [[ $4 == 'lsstat_drive_mb' ]]; then
  NODE_ID=$5
  RESULT=$(sshpass -p $3 ssh -o StrictHostKeyChecking=no $2@$1 '( lsnodecanisterstats )' )
  echo "$RESULT" |awk '$1=='"$NODE_ID"' && $3=="drive_mb" {print $4}'
fi

# lsstat_drive_io -> average drives I/O ops, IOPS
if [[ $4 == 'lsstat_drive_io' ]]; then
  NODE_ID=$5
  RESULT=$(sshpass -p $3 ssh -o StrictHostKeyChecking=no $2@$1 '( lsnodecanisterstats )' )
  echo "$RESULT" |awk '$1=='"$NODE_ID"' && $3=="drive_io" {print $4}'
fi

# lsstat_drive_ms -> average drives I/O ops latency, ms
if [[ $4 == 'lsstat_drive_ms' ]]; then
  NODE_ID=$5
  RESULT=$(sshpass -p $3 ssh -o StrictHostKeyChecking=no $2@$1 '( lsnodecanisterstats )' )
  echo "$RESULT" |awk '$1=='"$NODE_ID"' && $3=="drive_ms" {print $4}'
fi

# lsstat_vdisk_w_mb -> average volumes write ops, MBps
if [[ $4 == 'lsstat_vdisk_w_mb' ]]; then
  NODE_ID=$5
  RESULT=$(sshpass -p $3 ssh -o StrictHostKeyChecking=no $2@$1 '( lsnodecanisterstats )' )
  echo "$RESULT" |awk '$1=='"$NODE_ID"' && $3=="vdisk_w_mb" {print $4}'
fi

# lsstat_vdisk_w_io -> average volumes write ops, IOPS
if [[ $4 == 'lsstat_vdisk_w_io' ]]; then
  NODE_ID=$5
  RESULT=$(sshpass -p $3 ssh -o StrictHostKeyChecking=no $2@$1 '( lsnodecanisterstats )' )
  echo "$RESULT" |awk '$1=='"$NODE_ID"' && $3=="vdisk_w_io" {print $4}'
fi

# lsstat_vdisk_w_ms -> average volumes write ops latency, ms
if [[ $4 == 'lsstat_vdisk_w_ms' ]]; then
  NODE_ID=$5
  RESULT=$(sshpass -p $3 ssh -o StrictHostKeyChecking=no $2@$1 '( lsnodecanisterstats )' )
  echo "$RESULT" |awk '$1=='"$NODE_ID"' && $3=="vdisk_w_ms" {print $4}'
fi

# lsstat_mdisk_w_mb -> average MDisks write ops, MBps
if [[ $4 == 'lsstat_mdisk_w_mb' ]]; then
  NODE_ID=$5
  RESULT=$(sshpass -p $3 ssh -o StrictHostKeyChecking=no $2@$1 '( lsnodecanisterstats )' )
  echo "$RESULT" |awk '$1=='"$NODE_ID"' && $3=="mdisk_w_mb" {print $4}'
fi

# lsstat_mdisk_w_io -> average MDisks write ops, IOPS
if [[ $4 == 'lsstat_mdisk_w_io' ]]; then
  NODE_ID=$5
  RESULT=$(sshpass -p $3 ssh -o StrictHostKeyChecking=no $2@$1 '( lsnodecanisterstats )' )
  echo "$RESULT" |awk '$1=='"$NODE_ID"' && $3=="mdisk_w_io" {print $4}'
fi

# lsstat_mdisk_w_ms -> average MDisks write ops latency, ms
if [[ $4 == 'lsstat_mdisk_w_ms' ]]; then
  NODE_ID=$5
  RESULT=$(sshpass -p $3 ssh -o StrictHostKeyChecking=no $2@$1 '( lsnodecanisterstats )' )
  echo "$RESULT" |awk '$1=='"$NODE_ID"' && $3=="mdisk_w_ms" {print $4}'
fi

# lsstat_drive_w_mb -> average drives write ops, MBps
if [[ $4 == 'lsstat_drive_w_mb' ]]; then
  NODE_ID=$5
  RESULT=$(sshpass -p $3 ssh -o StrictHostKeyChecking=no $2@$1 '( lsnodecanisterstats )' )
  echo "$RESULT" |awk '$1=='"$NODE_ID"' && $3=="drive_w_mb" {print $4}'
fi

# lsstat_drive_w_io -> average drives write ops, IOPS
if [[ $4 == 'lsstat_drive_w_io' ]]; then
  NODE_ID=$5
  RESULT=$(sshpass -p $3 ssh -o StrictHostKeyChecking=no $2@$1 '( lsnodecanisterstats )' )
  echo "$RESULT" |awk '$1=='"$NODE_ID"' && $3=="drive_w_io" {print $4}'
fi

# lsstat_drive_w_ms -> average drives write ops latency, ms
if [[ $4 == 'lsstat_drive_w_ms' ]]; then
  NODE_ID=$5
  RESULT=$(sshpass -p $3 ssh -o StrictHostKeyChecking=no $2@$1 '( lsnodecanisterstats )' )
  echo "$RESULT" |awk '$1=='"$NODE_ID"' && $3=="drive_w_ms" {print $4}'
fi

# lsstat_vdisk_r_mb -> average volumes read ops, MBps
if [[ $4 == 'lsstat_vdisk_r_mb' ]]; then
  NODE_ID=$5
  RESULT=$(sshpass -p $3 ssh -o StrictHostKeyChecking=no $2@$1 '( lsnodecanisterstats )' )
  echo "$RESULT" |awk '$1=='"$NODE_ID"' && $3=="vdisk_r_mb" {print $4}'
fi

# lsstat_vdisk_r_io -> average volumes read ops, IOPS
if [[ $4 == 'lsstat_vdisk_r_io' ]]; then
  NODE_ID=$5
  RESULT=$(sshpass -p $3 ssh -o StrictHostKeyChecking=no $2@$1 '( lsnodecanisterstats )' )
  echo "$RESULT" |awk '$1=='"$NODE_ID"' && $3=="vdisk_r_io" {print $4}'
fi

# lsstat_vdisk_r_ms -> average volumes read ops latency, ms
if [[ $4 == 'lsstat_vdisk_r_ms' ]]; then
  NODE_ID=$5
  RESULT=$(sshpass -p $3 ssh -o StrictHostKeyChecking=no $2@$1 '( lsnodecanisterstats )' )
  echo "$RESULT" |awk '$1=='"$NODE_ID"' && $3=="vdisk_r_ms" {print $4}'
fi

# lsstat_mdisk_r_mb -> average MDisks read ops, MBps
if [[ $4 == 'lsstat_mdisk_r_mb' ]]; then
  NODE_ID=$5
  RESULT=$(sshpass -p $3 ssh -o StrictHostKeyChecking=no $2@$1 '( lsnodecanisterstats )' )
  echo "$RESULT" |awk '$1=='"$NODE_ID"' && $3=="mdisk_r_mb" {print $4}'
fi

# lsstat_mdisk_r_io -> average MDisks read ops, IOPS
if [[ $4 == 'lsstat_mdisk_r_io' ]]; then
  NODE_ID=$5
  RESULT=$(sshpass -p $3 ssh -o StrictHostKeyChecking=no $2@$1 '( lsnodecanisterstats )' )
  echo "$RESULT" |awk '$1=='"$NODE_ID"' && $3=="mdisk_r_io" {print $4}'
fi

# lsstat_mdisk_r_ms -> average MDisks ops latency, ms
if [[ $4 == 'lsstat_mdisk_r_ms' ]]; then
  NODE_ID=$5
  RESULT=$(sshpass -p $3 ssh -o StrictHostKeyChecking=no $2@$1 '( lsnodecanisterstats )' )
  echo "$RESULT" |awk '$1=='"$NODE_ID"' && $3=="mdisk_r_ms" {print $4}'
fi

# lsstat_drive_r_mb -> average drives read ops, MBps
if [[ $4 == 'lsstat_drive_r_mb' ]]; then
  NODE_ID=$5
  RESULT=$(sshpass -p $3 ssh -o StrictHostKeyChecking=no $2@$1 '( lsnodecanisterstats )' )
  echo "$RESULT" |awk '$1=='"$NODE_ID"' && $3=="drive_r_mb" {print $4}'
fi

# lsstat_drive_r_io -> average drives read ops, IOPS
if [[ $4 == 'lsstat_drive_r_io' ]]; then
  NODE_ID=$5
  RESULT=$(sshpass -p $3 ssh -o StrictHostKeyChecking=no $2@$1 '( lsnodecanisterstats )' )
  echo "$RESULT" |awk '$1=='"$NODE_ID"' && $3=="drive_r_io" {print $4}'
fi

# lsstat_drive_r_ms -> average drives read ops latency, ms
if [[ $4 == 'lsstat_drive_r_ms' ]]; then
  NODE_ID=$5
  RESULT=$(sshpass -p $3 ssh -o StrictHostKeyChecking=no $2@$1 '( lsnodecanisterstats )' )
  echo "$RESULT" |awk '$1=='"$NODE_ID"' && $3=="drive_r_ms" {print $4}'
fi

# lsstat_iplink_mb -> IP replication traffic, MBps
if [[ $4 == 'lsstat_iplink_mb' ]]; then
  NODE_ID=$5
  RESULT=$(sshpass -p $3 ssh -o StrictHostKeyChecking=no $2@$1 '( lsnodecanisterstats )' )
  echo "$RESULT" |awk '$1=='"$NODE_ID"' && $3=="iplink_mb" {print $4}'
fi

# lsstat_iplink_io -> IP partnership traffic, IOPS
if [[ $4 == 'lsstat_iplink_io' ]]; then
  NODE_ID=$5
  RESULT=$(sshpass -p $3 ssh -o StrictHostKeyChecking=no $2@$1 '( lsnodecanisterstats )' )
  echo "$RESULT" |awk '$1=='"$NODE_ID"' && $3=="iplink_io" {print $4}'
fi
