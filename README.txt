Social network


INSTALATION

#First option having the sn.tar.gz file
#First copy the sn script to a directory of your local disk and execute there the following commands
tar -xzf sn.tar.gz
cd sn/
chmod +x sn.sh #Make the script executable
./sn.sh #Plus any argument in order to execute it, if without any argument, then the help documentation will be shown

#Second option without having the sn.tar.gz file
#First copy the sn script to a directory of your local disk and execute there the following commands
git clone https://github.com/manuelmpouras/sn
cd sn/
chmod +x sn.sh #Make the script executable
./sn.sh #Plus any argument in order to execute it, if without any argument, then the help documentation will be shown

USE

  join                  Join our CoolNetwork,
                        clones it in your curent directory
                        and registers you with your github's account.


  create                Create a new social network a with the name
                        defined as the second argument
                        in your current directory.


  show_members          Shows the names
                        registed in our CoolNetwork.


  pull                  Pull in your local directory
                        all the posts and likes of the CoolNetwork.


  log                   List all the posts and likes of the CoolNetwork.


  like                  Like a specified post
  
  
  post		        Post a new story


  push            	Push a locally changed file to the CoolNetwork


  show_all_posts        Show all the posts posted on the CoolNetwork


  show_favorite_post    Show the post with the most likes
		        on the CoolNetwork


  follow	     	Follow a specified user of the CoolNetwork,
		      	the posts of this specific user will 
		        be copied to your /CoolNetwork/mywall 
	                local directory


  unfollow	        Unfollow a specified user of the CoolNetwork,
		        the posts of this specific user will 
	                be copied to your /CoolNetwork/mywall 
                  	local directory"
