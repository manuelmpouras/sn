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
##Joining in an already existing social network (git repository) and cloning it in the current directory
  if ! [ -d CoolNetwork/ ] ; then
    git clone https://github.com/manuelmpouras/CoolNetwork
	echo $(whoami)>>$(pwd)"/CoolNetwork/users.log"
	cd $(pwd)"/CoolNetwork/"
	git add "users.log"
	git commit -m "New member registered"
	git remote add origin https://github.com/manuelmpouras/CoolNetwork
	git push -u origin master
	if [ $? -ne 0 ] ; then
		echo Oooops. Registration failed. I am sorry you should login in your github\' account.
		rm -rf ../CoolNetwork/
	else
		cd ..
	fi
  else
	echo "You have already been registered. Thank you for joining our CoolNetwork."

  fi
}

sub_show()
{
##Joining in an already existing social network (git repository) and cloning it in the current directory
git log --pretty=format:%an |
sort |
uniq && echo " THE MEMBERS REGISTERED"

}

sub_help()
{
## In case of typing anything other than a specified argument of sn, then help page will be displayed 
echo "|
Start an issue repository
  join			Join our CoolNetwork, |
			clones it in your curent directory
			and registers you with your github's account.
			
  create		Create a new social network a with the name 
			defined as the second argument 
			in your current directory.
			
  show_members		Shows the names 
			registed in our CoolNetwork."
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
  show_members)
  sub_show
  ;;
  help)
  sub_help
  ;;
    *)
  sub_help
  exit 1
  ;;

  esac
