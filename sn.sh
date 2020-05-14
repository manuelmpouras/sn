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
##Show all the members registered in the CoolNetwork
if ! [ -d CoolNetwork/ ] ; then
	git clone https://github.com/manuelmpouras/CoolNetwork
	cd $(pwd)"/CoolNetwork/"
	git log --pretty=format:%an |
	sort |
	uniq && echo " THE MEMBERS REGISTERED"
else
	cd $(pwd)"/CoolNetwork/"
	git log --pretty=format:%an |
	sort |
	uniq && echo " THE MEMBERS REGISTERED"
fi
}
sub_pull()
{
##Pull all the new posts and likes of the CoolNetwork
	if [ -d CoolNetwork/ ] ; then
		rm -rf CoolNetwork/
	fi
	git clone https://github.com/manuelmpouras/CoolNetwork
	echo " Posts and likes pulled correctly"
	echo " You can see all of them in your local CoolNetwork directory"
}

sub_log()
{
##List all the posts and likes of the CoolNetwork
	if ! [ -d CoolNetwork/ ] ; then
		echo Plese first pull the latest changes with /sn pull/
	else
		cd $(pwd)"/CoolNetwork/"
		find . -name "*.post" |
		sort |
		uniq |
		while read post ; do
#			The number of likes is reported in the third line of the file "$post.info"
			name_post= echo -n $post | cut -d '/' -f 2 | tr -d '\n'
			echo -n " is a post with number of likes " && sed -n 3p "$post.info" 
		done
		echo " You can see all of them in your local CoolNetwork directory"
	fi
}

sub_help()
{
## In case of typing anything other than a specified argument of sn, then help page will be displayed 
echo "|
Start an issue repository

  join			Join our CoolNetwork, 
			clones it in your curent directory
			and registers you with your github's account.
			
			
  create		Create a new social network a with the name 
			defined as the second argument 
			in your current directory.
			
			
  show_members		Shows the names 
			registed in our CoolNetwork.
			
			
  pull			Pull in your local directory 
			all the posts and likes of the CoolNetwork.
			
			
  log			List all the posts and likes of the CoolNetwork."

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
  pull)
  sub_pull
  ;;
  log)
  sub_log
  ;;
  help)
  sub_help
  ;;
    *)
  sub_help
  exit 1
  ;;

  esac
