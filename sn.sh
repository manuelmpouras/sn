#!/bin/sh
sub_new()
{
echo "$1"
##Creating a local Social Network (git repository) in the current directory
  if [ "$1" ] ; then
    git init $(pwd)"/""$1"
	echo $(whoami)>>$(pwd)"/"$1"/users.log"
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
	echo $(whoami)>>$(pwd)"/CoolNetwork/users.log"
	cd $(pwd)"/CoolNetwork/"
	git add "users.log"
	git commit -m "New member registered"
	git remote add origin https://github.com/manuelmpouras/CoolNetwork
	git push -u origin master
	echo $(pwd)"/CoolNetwork/users.log"
	cd ..
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
