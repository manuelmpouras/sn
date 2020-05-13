#!/bin/sh
sub_new()
{
echo "$1"
##Creating a local Social Network (git repository) in the current directory
  if [ "$1" ] ; then
    git init $(pwd)"/""$1"
	cd $(pwd)"/""$1"
	echo $(whoami)
  else
	echo "Please define the name of the social network"

  fi

}

sub_join()
{
echo "$1"
##Joining in an already existing social network (git repository) and cloning it in the current directory
  if [ "$1" ] ; then
    git clone https://github.com/manuelmpouras/CoolNetwork
	cd $(pwd)"/""CoolNetwork"
	echo $(whoami)
	echo $0 $1
  else
	echo "Please define the name of the social network"

  fi

}
subcommand="$1"
net_name="$2"
shift
case "$subcommand" in
  create)
  sub_new "$@"
  ;;
  join)
  sub_join "$@"
  ;;
  esac
