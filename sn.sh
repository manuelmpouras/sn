#!/bin/sh
##Creating a local Social Network (git repository) in the current directory
sub_new()
{
echo "$1"
  if [ "$1" ] ; then
    git init $(pwd)"/""$1"
	echo $(whoami)>>$(pwd)"/"$1"/users.log"
	echo $(whoami)
  else
	echo "Please define the name of the social network"

  fi

}

##Joining in an already existing social network (git repository) and cloning it in the current directory
sub_join()
{
  if ! [ -d CoolNetwork/ ] ; then
    git clone https://github.com/manuelmpouras/CoolNetwork
	git config --global user.name $(whoami)
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

##Show all the members registered in the CoolNetwork
sub_show_members()
{
if ! [ -d CoolNetwork/ ] ; then
	git clone https://github.com/manuelmpouras/CoolNetwork
	cd $(pwd)"/CoolNetwork/"
	cat users.log |
	sort |
	uniq && echo " THE MEMBERS REGISTERED"
else
	cd $(pwd)"/CoolNetwork/"
	cat users.log |
	sort |
	uniq && echo " THE MEMBERS REGISTERED"
fi
}
##Pull all the new posts and likes of the CoolNetwork
sub_pull()
{
	if [ -d CoolNetwork/ ] ; then
		rm -rf CoolNetwork/
	fi
	git clone https://github.com/manuelmpouras/CoolNetwork
	echo " Posts and likes pulled correctly"
	echo " You can see all of them in your local CoolNetwork directory"
}

##List all the posts and likes of the CoolNetwork
sub_log()
{
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
##Show a specified post of the CoolNetwork
sub_show()
{
	if ! [ -d CoolNetwork/ ] ; then
		echo Plese first pull the latest changes with /sn pull/
	else
		if [ "$1" ] ; then
			cd $(pwd)"/CoolNetwork/"
				echo -n "$1:"
				test -f $1 || echo Is not a corect name /e.g. 1.post or 2.post etc./
				test -f $1 && cat $(pwd)"/"$1
		else 
			echo Please define a corect name /e.g. 1.post or 2.post etc./ of an existing post
		fi
	fi
}
##Like a specified post of the CoolNetwork
sub_like()
{
	if ! [ -d CoolNetwork/ ] ; then
		echo Plese first pull the latest changes with /sn pull/
	else
		if [ "$1" ] ; then
			cd $(pwd)"/CoolNetwork/"
			echo "$1"
				test -f $1 || echo Is not a corect name /e.g. 1.post or 2.post etc./
				if test -f $1 ; then
					likes=$(sed -n 3p "$1.info") && user=$(sed -n 1p "$1.info") && date=$(sed -n 2p "$1.info") && echo $user | cat>"$1.info"; echo $date | cat>>"$1.info" && echo $likes+1 | bc | cat>>"$1.info"
					git add "$1.info"
					git commit -m "New like"
					git remote add origin https://github.com/manuelmpouras/CoolNetwork
					git push -u origin master
					if [ $? -ne 0 ] ; then
						echo Oooops. Registration failed. I am sorry you should login in your github\' account.
					else
						cd ..
					fi

				fi
		else 
			echo Please define a corect name /e.g. 1.post or 2.post etc./ of an existing post
		fi
	fi
}
##Post a new story on the CoolNetwork
sub_post()
{
	if ! [ -d CoolNetwork/ ] ; then
		echo Plese first pull the latest changes with /sn pull/
	else
		cd $(pwd)"/CoolNetwork/"
		num=$(find . -name "*.post" |
		wc -l )
		n=$(expr $num + 1)
		echo "$@" | cat> $n.post
		echo $n
		echo $(whoami)>"$n.post.info"
		echo $(date)>>"$n.post.info"
		echo 0 >>"$n.post.info"
		git add "$n.post"
		git add "$n.post.info"
		git commit -m "New story"
		git remote add origin https://github.com/manuelmpouras/CoolNetwork
		git push -u origin master
		if [ $? -ne 0 ] ; then
			echo Oooops. Registration failed. I am sorry you should login in your github\' account.
		else
			cd ..
		fi
	fi
}

##Push a locally changed file to the CoolNetwork
sub_push()
{
	if ! [ -d CoolNetwork/ ] ; then
		echo Plese first pull the latest changes with /sn pull/
	else
		if [ "$1" ] && test -f CoolNetwork/$1; then
			cd $(pwd)"/CoolNetwork/"
			git add "$1"
			git commit -m "new push from local changes"
			git remote add origin https://github.com/manuelmpouras/CoolNetwork
			git push -u origin master
			if [ $? -ne 0 ] ; then
				echo Oooops. Registration failed. I am sorry you should login in your github\' account.
			else
				cd ..
			fi
		else 
			echo Please define just the name of the local file, you changed in the locally cloned repository of the CoolNetwork, you want to push
		fi
	fi
}

##Show all posts of the CoolNetwork
sub_show_all_posts()
{
	if ! [ -d CoolNetwork/ ] ; then
		echo Plese first pull the latest changes with /sn pull/
	else
				cd CoolNetwork/
				find . -name "*.post" |
				while read f ; do
					echo $f
					cat $f
				done
	fi
}
##Follow a specified user of the CoolNetwork, the posts of this specific user will be copied to your /CoolNetwork/mywall local directory
sub_follow()
{
	if ! [ -d CoolNetwork/ ] ; then
		echo Plese first pull the latest changes with /sn pull/
	else
		if [ "$1" ] ; then
			cd $(pwd)"/CoolNetwork/"
			test -d $(pwd)/mywall || mkdir $(pwd)/mywall
			flag=0
			find *.post |
			while read posts ; do
				user=$(sed -n 1p $posts".info")
				if [ $user == $1 ] ; then
					cp $posts $(pwd)/mywall/$posts && echo $posts of $1 has been copied successfully to my local ./CoolNetwork/mywall directory. && touch $(pwd)/mywall/null
				fi
			done
			test -f $(pwd)/mywall/null || echo I am sorry there no any post of this user yet
			test -f $(pwd)/mywall/null && rm $(pwd)/mywall/null
		else
			echo Please enter the user name you want to follow
		fi
	fi
}
##Unfollow a specified user of the CoolNetwork, the posts of this specific user will be deleted for your /CoolNetwork/mywall local directory
sub_unfollow()
{
	if ! [ -d CoolNetwork/ ] ; then
		echo Plese first pull the latest changes with /sn pull/
	else
		if [ "$1" ] ; then
			cd $(pwd)"/CoolNetwork/"
			test -d $(pwd)/mywall || mkdir $(pwd)/mywall
			find *.post |
			while read posts ; do
				user=$(sed -n 1p $posts".info")
				if [ $user == $1 ] ; then
					test -f $(pwd)/mywall/$posts && rm $(pwd)/mywall/$posts && echo $posts of $1 has been deleted successfully from my local ./CoolNetwork/mywall directory. && touch $(pwd)/mywall/null
				fi
			done
			test -f $(pwd)/mywall/null || echo I am sorry you do not follow any user with this name yet
			test -f $(pwd)/mywall/null && rm $(pwd)/mywall/null
		else
			echo Please enter the user name you want to follow
		fi
	fi
}
## In case of typing anything other than a specified argument of sn, then help page will be displayed 
sub_help()
{
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


  log			List all the posts and likes of the CoolNetwork.


  like			Like a specified post


  post			Post a new story


  push			Push a locally changed file to the CoolNetwork


  follow		Follow a specified user of the CoolNetwork,
			the posts of this specific user will 
			be copied to your /CoolNetwork/mywall 
			local directory


  unfollow		Unfollow a specified user of the CoolNetwork,
			the posts of this specific user will 
			be copied to your /CoolNetwork/mywall 
			local directory"

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
  sub_show_members
  ;;
  pull)
  sub_pull
  ;;
  log)
  sub_log
  ;;
  show)
  sub_show "$@"
  ;;
  like)
  sub_like "$@"
  ;;
  post)
  sub_post "$@"
  ;;
  push)
  sub_push "$@"
  ;;
  show_all_posts)
  sub_show_all_posts
  ;;
  follow)
  sub_follow "$@"
  ;;
  unfollow)
  sub_unfollow "$@"
  ;;
  help)
  sub_help
  ;;
    *)
  sub_help
  exit 1
  ;;

  esac
