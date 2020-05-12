#!/bin/sh
sub_new()
{

echo "$1" "$2"

}

subcommand="$1"
net_name="$2"
shift
case "$subcommand" in
  create)
  sub_new "$subcommand" "$net_name"
  ;;
  esac
