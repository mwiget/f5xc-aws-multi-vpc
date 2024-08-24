#!/bin/bash
instance_type=$1

if [ -z "${instance_type}" ]; then
  echo "$0 <instance_type>"
  echo ""
  echo "e.g. $0 c5.*"
  exit 1
fi

echo "instance_type=($instance_type) ..."

aws ec2 describe-instance-types \
  --filters "Name=instance-type,Values=$instance_type" \
  --query "InstanceTypes[].[InstanceType, NetworkInfo.NetworkPerformance, NetworkInfo.NetworkCards[0].BaselineBandwidthInGbps, NetworkInfo.MaximumNetworkInterfaces] \
   | sort_by(@,&[2])" --output table

# sort by MaximumNetworkInterfaces:
   # | sort_by(@,&[3])" --output table
