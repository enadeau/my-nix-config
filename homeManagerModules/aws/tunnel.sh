#!/bin/bash

set -euox pipefail

function run() {
  local local_port remote_port
  local_port="$1"
  remote_port="$2"


  INSTANCE_ID=$(
    aws ec2 describe-instances \
      --filters "Name=tag:Name,Values=bastion-${aws_env}" "Name=instance-state-name,Values=running" \
      --query "Reservations[0].Instances[0].InstanceId" \
      --region eu-west-1 \
      --output text
  )

  echo "Starting port forwarding session with instance $INSTANCE_ID for profile $AWS_PROFILE"
  echo "Connecting to $option from $local_port to $remote_port"
  aws ssm start-session \
    --target "$INSTANCE_ID" \
    --document-name AWS-StartPortForwardingSession \
    --parameters '{"localPortNumber":["'"$local_port"'"], "portNumber":["'"$remote_port"'"]}' \
    --region eu-west-1
}


usage() {
  echo "Usage: $(basename $0) redis|db" 2>&1
  exit 1
}

if [[ ${#} -eq 0 ]]; then
  usage
fi

option=$1
aws_env="${2:-dev}"

case $option in
  db-reader) run "5433" "5433" ;;
  db-writer) run "5434" "5434" ;;
  db-proxy) run "5435" "5435" ;;
  redis-reader) run "6380" "6380" ;;
  redis-writer) run "6381" "6381" ;;

  es) run "9200" "9200" ;;
  *) usage ;;

esac

echo "done!"
