#!/bin/sh
sub_new()
{
echo "$1"
git init remote "$1"
#git push "$1"
  if ! [ "$1" ] ; then
    git init -q || error 'Unable to initialize Git directory'
  fi


}

subcommand="$1"
net_name="$2"
shift
case "$subcommand" in
  create)
  sub_new "$@"
  ;;
  esac
