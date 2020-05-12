#!/bin/sh
sub_new()
{
echo "$1"
cd
git init "$1"
cd ./"$1"
git remote add origin "https://github.com/manuelmpouras/"$1
git push -u origin master
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
