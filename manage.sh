#!/bin/bash
#Subin Gyawali

# -------------------------------------USER GUIDE-------------------------------------

# o	Navigate to the directory of file using cd command
# o	Run the program with command: bash manange.sh or ./manage.sh
# o	Press ‘x’ as input anywhere in the program to exit the program

# o	Press 1 to enter Archive Management Console

# 		Press 1 to Set up archive cron settings
# 		•	A window will open allowing you to enter timings for the cron job. 
# 			Enter minute, hour, day of month, month and day of week based on your requirement
# 		•	A window will open allowing you to choose source folder or the folder you want to archive
# 		•	A window will open allowing you to choose destination folder to keep the archived file
# 		•	A window will open allowing you to enter the  name of the archived file without any extension
# 		•	The program will set up a cron job and will archive the chosen files on specified 
# 			time and will show a notification each time after archiving

# 		Press 2 to clear all existing crontab jobs for the user
# 		•	The program clears all the existing cron jobs for the user

# o	Press 2 to enter User Management Console
# *User must have root privileges to run user management console

# 		Press 1 to add new user
# 		•	Enter the name of the new user
# 		•	Enter the username of the new user
# 		•	Enter the password for the new user
# 		•	The program adds a new user to the system
# 		Press 2 to add new group
# 		•	Enter the name of the new group
# 		•	The program adds a new group to the system
# 		Press 3 to edit existing user
# 		•	Enter the name of the user to edit
# 		•	The program shows edit options if the username is valid
# 			o	Press 1 to Rename user
# 					Enter the new username for the user and press enter
# 			o	Press 2 to change user password
# 					Enter new password for the user and press enter
# 			o	Press 3 to lock user
# 					The program locks the user if it is unlocked
# 			o	Press 4 to unlock user
# 					The program unlocks the user if it is locked
# 			o	Press 5 to set account expiry date
# 					Choose a date from the window to set it as account expiry date
# 			o	Press 6 to assign user to a group
# 					Enter name of the existing group to add user to it
# 			o	Press 7 to see groups that the user belongs to
# 					The program shows all the groups that the user belongs to
# 		Press 4 to edit existing group
# 		•	Enter the name of the group to edit
# 		•	The program shows edit options if the group name is valid
# 			o	Press 1 to Rename group
# 					Enter the new group name and press enter
# 			o	Press 2 to set group password
# 					Enter password for the group and press enter
# 			o	Press 3 to add a group administrator
# 					Enter the name of the existing user to set user as group admin
# 			o	Press 4 to add a user to the group
# 					Enter the name of the existing user to add to the group
# 			o	Press 5 to remove the user from group
# 					Enter the username of the user belonging to the group

# 		Press 5 to delete an existing user
# 		•	Enter the name of the existing user to delete from the system
# 		Press 6 to delete an existing group
# 		•	Enter the name of the existing name of the group to remove from the system
# 		Press 7 to view all users on the system
# 		•	The program shows all the users in the system 
# 		Press 8 to view all the groups on the system
# 		•	The program shows all the groups in the system
# 		Press 9 to view users in a group
# 		•	Enter the name of the group to view users in it

# ------------------------------------------------------------------------------------

# Clearing all previous tput config
tput sgr0 
# clearing the screen at the starting of the program
tput clear

# Defining variable to store position for success messages
successX=8
# Defining regex strings to compare to input values for verification
nameRegex='^[a-z|A-Z|" "]+$'
usernameRegex='^[a-z|A-Z|0-9]+$'
passRegex='^[a-zA-Z0-9~@#$^*()_+={}|\\,.?:-]+$'

# Creating a function check to check if the given input was x
# exiting the application if yes
check (){
	if [ $1 = x ] 
	then 
      # clearing the screen and clearing all set tput properties
		tput clear 
		tput sgr0 
		exit
	fi
}

# Creating function checkFunction to check if the input value was x
# and running the respective function 
checkFunction(){
	if [ $1 = x ] 
	then 
      # clearing the screen and clearing all set tput properties
		tput clear 
		tput sgr0 
		$2
	fi
}
# CHECK FUNCTION AND CHECK HAVE BEEN CALLED IN MANY PLACES IN THE PROGRAM TO CHECK IF THE PROVIDED INPUT IS 'X' 
# THE FIRST PARAMETER DEFINES THE INPUT VALUE WHEREAS THE SECOND PARAMETER DEFINES THE FUNCTION TO BE EXECUTED
# IF 'X' WAS PRESSED 

# Creating a function to greet when each option is selected
greetFunction(){
	# Clears the screen
	clear	
	# Greetings
	tput cup 2 20
	tput rev
	echo " $1 "
	tput sgr0
}
# GREET FUNCTION HAS BEEN CALLED IN MANY PLACES IN THE PROGRAM 
# TO GREET AT THE START OF THE SPECIFIC SECTION OF THE PROGRAM
# IT TAKES THE STRING TO BE DISPLAYED AS ARGUMENT

# Defining function showError to show erros on the zenity window
showError(){
	tput sgr0
	zenity --error --no-wrap --title="Input Error" --text="$1"
}

# Defining function showMessage to show Info Messages on the zenity window
showMessage(){
	tput sgr0
	zenity --info --no-wrap --title="Message" --text="$1"
}

# SHOW ERROR AND SHOW MESSAGE FUNCTIONS HAVE BEEN CALLED IN MANY PLACES IN THE PROGRAM
# TO SHOW THE ERROR AND MESSAGE RESPECTIVELY
# BOTH THE FUNCTIONS TAKE THE STRING TO BE DISPLAYED AS ARGUMENT
# THE ZENITY PACKAGE HAS BEEN USED TO SHOW THE ERRORS AND MESSAGES IN THE WINDOW

# Creating addUser function to add a new user
addUser(){
	greetFunction "Add User"

	# Taking user's full name as input
	tput setaf 4
	tput cup 4 20
	read -p "Enter User's Full Name: " name
	checkFunction $name userManager
	if [[ $name =~ $nameRegex ]]
	then
		# taking username of the user to be added
		tput cup 5 20
		read -p "Enter Username: " username
		checkFunction $username userManager

		# checking if the provided username is valid
		if [[ $username =~ $usernameRegex ]]
		then
			# checking if the provided username already exists
			exists=$(grep -c "$username" /etc/passwd)
			if [[ $exists -eq 0 ]]
			then
				# taking user password if the provided username is unique
				tput cup 6 20
				read -p "Enter User Password: " pass
				checkFunction $pass userManager

				# checking if the provided password is valid
				if [[ $pass =~ $passRegex ]]
				then	
					tput cup 7 20
					# using useradd to add user
					# here, m tells to make home directory by default for the user
					# N tells not to create a default group
					# c has been used to provide a comment which has been supplied with user's full name
					# p has been defined to set the user password
					sudo useradd -N -m -c "$name" -p "$pass" $username
					showMessage "User Added Successfully."
					reRunUser
				else
					showError "Invalid Password.\nSpaces and Special Characters are Not Allowed."
					addUser
				fi
			else
				showError "User Already Exists."
				userManager
			fi
		else
			showError "Invalid Username.\nSpaces and Special Characters are Not Allowed."
			addUser
		fi
	else
		showError "Invalid Name.\nCharacters and Numbers are Not Allowed."
		addUser
	fi
}


# Creating addGroup function to add a new group
addGroup(){
	greetFunction "Add Group"

	tput setaf 4
	tput cup 4 20
	# taking group name as input
	read -p "Enter Group Name: " groupname
	checkFunction $groupname userManager

	# Checking if the valid group name was provided
	if [[ $groupname =~ $usernameRegex ]]
		then
			# Checking if the group already exists in the system
			# here 'c' defines the count of occurance of the username provided
			exists=$(grep -c "$groupname" /etc/group)
			if [[ $exists -eq 0 ]]
			then
				# adding new group using groupadd
				sudo groupadd "$groupname"
				showMessage "Group Added Successfully."
				reRunUser
			else
				showError "Group Already Exists."
				userManager
			fi
	else
		showError "Invalid Group Name.\nSpaces and Special Characters are Not Allowed."
		addGroup
	fi
}


# Creating deleteUser function to delete an existing user
deleteUser(){
	greetFunction "Delete User"

	tput setaf 4
	tput cup 4 20
	# taking username to be Deleted as input
	read -p "Enter Username to Delete: " username
	checkFunction $username userManager

	# checking if the provided username is valid
	if [[ $username =~ $usernameRegex ]]
	then	
		tput setaf 4
		tput cup 6 20
		# Checking if the provided user exists in the system
		exists=$(grep -c "$username" /etc/passwd)
		tput sgr0
		if [[ $exists -eq 1 ]]
		then
			# Deleting provided user using userdel
			# here 'r' defines to delete home folder too
			sudo userdel -r "$username"
			showMessage "User Deleted Successfully."
			reRunUser
		else
			showError "User Doesn't Exist."
			deleteUser
		fi
	else
		showError "Invalid Username."
		deleteUser
	fi
}

# Creating deleteGroup function to delete an existing group
deleteGroup(){
	greetFunction "Delete Group"

	tput setaf 4
	tput cup 4 20
	# Taking username of the group to be Deleted as input
	read -p "Enter Group Name to Delete: " username
	checkFunction $username userManager

	# checking if the provided username is valid
	if [[ $username =~ $usernameRegex ]]
	then
		tput setaf 4
		tput cup 6 20
		# Checking if the provided group exits in the system
		exists=$(grep -c "$username" /etc/group)
		tput sgr0
		if [[ $exists -eq 1 ]]
		then
			# Deleting group using groupdel
			sudo groupdel "$username"
			showMessage "Group Deleted Successfully."
			reRunUser
		else
			showError "Group Doesn't Exist."
			deleteGroup
		fi
	else
		showError "Invalid Group Name."
		deleteGroup
	fi
}

# Creating editUser function to edit an existing user
editUser(){
	greetFunction "Edit User"

	tput setaf 4
	tput cup 4 20
	# Taking the username of the user to be edited as input
	read -p "Enter Username to Edit: " username
	checkFunction $username userManager

	# Checking if the provided username is valid
	if [[ $username =~ $usernameRegex ]]
	then	
		tput setaf 4
		tput cup 6 20
		# Checking if the user exists in the system
		exists=$(grep -c "$username" /etc/passwd)
		tput sgr0
		if [[ $exists -eq 1 ]]
		then
			editUserMenu $username
		else
			showError "User Doesn't Exist."
			editUser
		fi
	else
		showError "Invalid Username."
		editUser
	fi
}

# Creating edituUserMenu function to display options for editing an user
editUserMenu(){
	greetFunction "Editing User '$1'"
	
	# Showing all the available options to act on users
	tput cup 5 20 
	echo 1. Rename User
	tput cup 6 20 
	echo 2. Change Password
	tput cup 7 20 
	echo 3. Lock User
	tput cup 8 20 
	echo 4. Unlock User
	tput cup 9 20
	echo 5. Set an Account Expiry Date
	tput cup 10 20 
	echo 6. Assign To a Group
	tput cup 11 20 
	echo 7. View Assigned Groups
	tput cup 12 20
	echo x To Exit From Anywhere

	tput bold 
	tput setaf 4
	tput cup 14 20 
	# Reading the choosen option value in the variable option
	read -p "Enter Your Choice: " option 
	tput sgr0

	# Validating the value of option variable
	# taking actions based on chosen value
	if [[ $option =~ [1-7]|[x] && $option -lt 8 ]]
	then
		# calling check function to check if the option value is equal to 'x'
		checkFunction $option editUser
		
		if [ $option -eq 1 ]
		then
			# calling renameUser Function to rename the selected user
			renameUser $1

		elif [ $option -eq 2 ]
		then
			# calling changeUserPass function to change the password for the selected user
			changeUserPass $1
			editUserMenu $1

		elif [ $option -eq 3 ]
		then
			# Using usermod to lock the selected user from login
			# here, 'L' defines to lock
			sudo usermod -L "$1"
			showMessage "User Locked."
			editUserMenu $1
		
		elif [ $option -eq 4 ]
		then
			# Using usermod to unlock the selected user from login
			# here, 'U' defines to unlock
			sudo usermod -U "$1"
			showMessage "User Unlocked."
			editUserMenu $1
		
		elif [ $option -eq 5 ]
		then
			# calling setExpiryDate function to set an expiry date for the user account
			setExpiryDate $1
			editUserMenu $1

		elif [ $option -eq 6 ]
		then
			# calling function assignToGroup to assing the selected user to a specified group
			assignToGroup $1
			editUserMenu $1

		elif [ $option -eq 7 ]
		then
			# using grep to show all the groups in the selected user is member
			groups=$(grep "$1" /etc/group)
			
			# here, 'cut' command has been used to cut the specific part of the output and display only the username
			# here, 'd' defines delimiter which tells to break the output from the defined character
			# 'f1' to get the first field out of broken fields
			groupsCut=$(echo "$groups" | cut -d ':' -f 1)

			# Using Zenity package to display a list window to display all groups where the selected user is member
			zenity --list --title="Groups List" --print-column=null --width 450 --height 350 --text="Groups Assigned to $1" --column="Groups" $groupsCut
			editUserMenu $1
		fi
	else 	
		# Executing userManager function to reRun User manager console
		editUser
	fi
}

# Creating editGroup function to edit an existing group
editGroup(){
	greetFunction "Edit Group"

	tput setaf 4
	tput cup 4 20
	# Taking the group username of the group to be edited as input
	read -p "Enter Group Name to Edit: " username
	checkFunction $username userManager

	# checking if the given username is valid
	if [[ $username =~ $usernameRegex ]]
	then
		tput setaf 4
		tput cup 6 20
		# checking if the given username exists in the system
		exists=$(grep -c "$username" /etc/group)
		tput sgr0
		if [[ $exists -eq 1 ]]
		then
			editGroupMenu $username
			reRunUser
		else
			showError "Group Doesn't Exist."
			editGroup
		fi
	else
		showError "Invalid Group Name."
		editGroup
	fi
}

# Creating edituGroupMenu function to display options for editing a group
editGroupMenu(){
	greetFunction "Editing Group '$1'"
	
	# Showing all the available options to act on groups
	tput cup 5 20 
	echo 1. Rename Group
	tput cup 6 20 
	echo 2. Set Group Password
	tput cup 7 20 
	echo 3. Add an Administrator
	tput cup 8 20 
	echo 4. Add a User
	tput cup 9 20 
	echo 5. Remove a User
	tput cup 10 20
	echo x To Exit From Anywhere


	tput bold 
	tput setaf 4
	tput cup 12 20 
	# Reading the choosen option value in the variable option
	read -p "Enter Your Choice: " option 
	tput sgr0

	# Validating the value of option variable
	# taking actions based on chosen value
	if [[ $option =~ [1-5]|[x] && $option -lt 6 ]]
	then
		# calling check function to check if the option value is equal to 'x'
		checkFunction $option editGroup
		
		if [ $option -eq 1 ]
		then
			# calling renameGroup function to rename the selected group
			renameGroup $1

		elif [ $option -eq 2 ]
		then
			# calling setGroupPass function to set the group password for the selected group
			setGroupPass $1
			# Recalling this function after a part of the program has been completed
			editGroupMenu $1 

		elif [ $option -eq 3 ]
		then
			# calling addAdmin function to add an Administrator to the selected group
			addAdmin $1
			editGroupMenu $1 
		
		elif [ $option -eq 4 ]
		then
			# calling addUserInGroup function to add an user to the selected group
			addUserInGroup $1
			editGroupMenu $1 

		elif [ $option -eq 5 ]
		then
			# calling removeUserFromGroup function to remove the specified user from the selected group
			removeUserFromGroup $1
			editGroupMenu $1 
		fi
	else 	
		# Executing userManager function to reRun User manager console
		editGroup
	fi
	
}

# Creating viewUsers function to view existing users
viewUsers(){
	greetFunction "View All Users"

	# Getting the list of all users present in the system from the folder /etc/passwd
	# here, 'cut' command has been used to cut the specific part of the output and display only the username
	# here, 'd' defines delimiter which tells to break the output from the defined character
	# 'f1' to get the first field out of broken fields
	users=$(cut -d: -f1 /etc/passwd)

	# Using Zenity package to display a window
	zenity --list --title="Users List" --print-column=null --width 450 --height 350 --text="List Of All Users" --column="Users" $users

	reRunUser
}

# Creating viewGroups function to view existing groups
viewGroups(){
	greetFunction "View All Groups"

	# Getting the list of all groups present in the system from the folder /etc/group
	# here, 'cut' command has been used to cut the specific part of the output and display only the username
	# here, 'd' defines delimiter which tells to break the output from the defined character
	# 'f1' to get the first field out of broken fields
	groups=$(cut -d: -f1 /etc/group)

	# Using Zenity package to display a list window to display all groups
	zenity --list --title="Groups List" --print-column=null --width 450 --height 350 --text="List Of All Groups" --column="Groups" $groups

	reRunUser
}

# Creating viewGroupUsers function to view users in a group
viewGroupUsers(){	
	greetFunction "View Users In a Group"

	tput setaf 4
	tput cup 4 20
	read -p "Enter Group Name to View Users: " username
	checkFunction $username userManager

	if [[ $username =~ $usernameRegex ]]
	then
		tput setaf 4
		tput cup 6 20
		# Checking if the group exists in the system
		# returns number greater than 0 if present
		exists=$(grep -c "$username" /etc/group)
		tput sgr0
		if [[ $exists -eq 1 ]]
		then
			# viewing all users in a selected group using groupmems
			# here 'g' defines group name
			# and 'l' defines to return a list 
			users=$(groupmems -g "$username" -l)
			# Using Zenity package to display a list window
			zenity --list --title="Users List" --print-column=null --width 450 --height 350 --text="List Of Users in $username Group" --column="Users" $users
			reRunUser
		else
			showError "Group Doesn't Exist."
			viewGroupUsers
		fi
	else
		showError "Invalid Group Name."
		viewGroupUsers
	fi
}

# USER EDIT MENU FUNCTIONS

# Creating function renameUser to rename the selected user
# Accepts user's username as argument
renameUser(){
	greetFunction "Rename User '$1'"

	tput setaf 4
	tput cup 4 20
	read -p "Enter New Username: " username
	tput sgr0

	checkFunction $username editUser

	# checking if the prvided username is valid
	if [[ $username =~ $usernameRegex ]]
	then
		# adding user using usermod
		# here, 'l' deines login name
		# 'm' defines to move home directory to a different place
		# 'd' defines the directory to be moved to
		sudo usermod -l "$username" -m -d /home/"$username" "$1"
		showMessage "Username Changed Successfully."
		editUserMenu $username
	else
		showError "Invalid Username.\nSpaces and Special Characters are Not Allowed."
		renameUser $1
	fi
}

# Creating function changeUserPass to change the specified user's password
# Accepts user's username as argument
changeUserPass(){
	greetFunction "Change User Password For '$1'"

	tput setaf 4
	tput cup 4 20
	read -p "Enter New Password: " pass
	tput sgr0

	checkFunction $pass editUser

	# checking if provided password is valid
	if [[ $pass =~ $passRegex ]]
	then
		# setting user password using usermod
		# here 'p' defines password
		sudo usermod -p "$pass" $1
		showMessage "Password Changed Successfully."
	else
		showError "Invalid Password.\nSpaces and Special Characters are Not Allowed."
		changeUserPass $1
	fi
}

# Creating function setExpiryDate to set the expiry date of the user Account
# Accepts user's username as argument
setExpiryDate(){
	greetFunction "Set Expiry Date For '$1'"

	tput setaf 4
	tput cup 4 20
	# using zenity package to allow user to select the date and get it
	date=$(zenity --calendar --text="Choose Expiry Date" --title="Expiry Date" --date-format="%Y-%m-%d" --width="400" --height="300")
	tput sgr0
	# Checking if user didn't select anything
	if [[ "$date" -eq null ]]
	then
		editUserMenu $1
	else
		# adding accout expiry date using usermod
		# here, 'e' defines expiry date 
		sudo usermod -e "$date" $1
		showMessage "Expiry Date Set Successfully."
	fi
}

# Creating function assignToGroup to assign the specified user to the specified group
# Accepts user's username as argument
assignToGroup(){
	greetFunction "Assign '$1' To A Group"

	tput setaf 4
	tput cup 4 20
	read -p "Enter Group Name To Assign: " username
	checkFunction $username editUser

	if [[ $username =~ $usernameRegex ]]
	then
		tput setaf 4
		tput cup 6 20
		# checking if the provided group name exists in the system
		# here, 'c' defines the count of the provided command output
		# this returns the number of existance of the username
		exists=$(grep -c "$username" /etc/group)
		tput sgr0
		if [[ $exists -eq 1 ]]
		then
			# adding user to the defined group using usermod
			# here, a defines to append
			# G defines the Group 
			sudo usermod -a -G "$username" "$1"
			showMessage "User Added Successfully to $username Group."
		else
			showError "Group Doesn't Exist."
			assignToGroup $1
		fi
	else
		showError "Invalid Group Name."
		assignToGroup $1
	fi
}

# GROUP EDIT MENU FUNCTIONS

# Creating function renameGroup to rename the specified group
# Accepts group username as argument
renameGroup(){
	greetFunction "Rename Group '$1'"

	tput setaf 4
	tput cup 4 20
	# taking new geoup name as input
	read -p "Enter New Group Name: " username
	checkFunction $username editGroup

	# checking if provided group username is valid
	if [[ $username =~ $usernameRegex ]]
	then
		# renaming group using groupmod
		# here, 'n' defines new name
		sudo groupmod -n "$username" $1
		showMessage "Group Successfully Renamed."
		editGroupMenu $username
	else
		showError "Invalid Group Name."
		renameGroup $1
	fi
}

# Creating function setGroupPass to set a group Password
# Accepts group username as argument
setGroupPass(){
	greetFunction "Set Group Password For '$1'"
	
	tput setaf 4
	tput cup 4 20
	read -p "Enter Group Password: " pass
	checkFunction $pass editGroup

	if [[ $pass =~ $passRegex ]]
	then
		# setting group password using groupmod
		# here, p defines password
		sudo groupmod -p "$pass" $1
		showMessage "Password Set Successfully."
	else
		showError "Invalid Password.\nSpaces and Special Characters are Not Allowed."
		changeGroupPass $1
	fi
}

# Creating function addAdmin to add an admin to the group
# Accepts group username as argument
addAdmin(){
	greetFunction "Add an Admin For '$1'"

	tput setaf 4
	tput cup 4 20
	read -p "Enter Admin Username: " username

	checkFunction $username userManager

	if [[ $username =~ $usernameRegex ]]
	then	
		tput setaf 4
		tput cup 6 20
		# checking if the provided user exists
		exists=$(grep -c "$username" /etc/passwd)
		tput sgr0
		if [[ $exists -eq 1 ]]
		then
			# adding an Administrator
			# here A defines to add an Admin
			sudo gpasswd -A "$username" $1
			showMessage "Admin Privileges Granted."
		else
			showError "User Doesn't Exist."
			addAdmin $1
		fi
	else
		showError "Invalid Username."
		addAdmin $1
	fi
}

# Creating function addUserInGroup to add an user to the specified group
# Accepts group username as argument
addUserInGroup(){
	greetFunction "Add an User In '$1'"

	tput setaf 4
	tput cup 4 20
	# Taking user's username to be added
	read -p "Enter User's Username: " username

	checkFunction $username userManager

	if [[ $username =~ $usernameRegex ]]
	then	
		tput setaf 4
		tput cup 6 20
		# checking if the user already exists in the system
		exists=$(grep -c "$username" /etc/passwd)
		tput sgr0
		if [[ $exists -eq 1 ]]
		then
			# adding user using gpasswd
			# here 'a' defines to append
			sudo gpasswd -a "$username" "$1"
			showMessage "User Added Successfully."
		else
			showError "User Doesn't Exist."
			addUserInGroup $1
		fi
	else
		showError "Invalid Username."
		addUserInGroup $1
	fi
}

# Creating function removeUserFromGroup to remove specified user from the selected group
# Accepts group username as argument
removeUserFromGroup(){
	greetFunction "Remove an User From '$1'"

	tput setaf 4
	tput cup 4 20
	read -p "Enter User's Username: " username

	checkFunction $username userManager

	if [[ $username =~ $usernameRegex ]]
	then	
		tput setaf 4
		tput cup 6 20
		# checking whether the specified username exists in the system or not
		exists=$(grep -c "$username" /etc/passwd)
		tput sgr0
		if [[ $exists -eq 1 ]]
		then
			# removing user if it exits in the specified group
			sudo gpasswd -d "$username" "$1"
			showMessage "User Removed Successfully."
		else
			showError "User Doesn't Exist."
			removeUserFromGroup $1
		fi
	else
		showError "Invalid Username."
		removeUserFromGroup $1
	fi
}

# Creating a Function userManager to handle user management
userManager(){
	clear	

	# Greetings
	tput cup 2 20
	tput setab 1
	tput bold
	echo " WELCOME TO USER MANAGER "
	tput sgr0

	# Displaying initial options to choose from at the start of the program for user management
	tput cup 5 20 
	echo 1. Add New User
	tput cup 6 20 
	echo 2. Add New Group
	tput cup 7 20 
	echo 3. Edit User
	tput cup 8 20 
	echo 4. Edit Group
	tput cup 9 20 
	echo 5. Delete User
	tput cup 10 20 
	echo 6. Delete Group
	tput cup 11 20 
	echo 7. View All Users
	tput cup 12 20
	echo 8. View All Groups
	tput cup 13 20
	echo 9. View Users In a Group
	tput cup 14 20
	echo x To Exit From Anywhere

	tput bold 
	tput setaf 4
	tput cup 16 20 
	# Reading the choosen option value in the variable option
	read -p "Enter Your Choice: " option 
	tput sgr0

	# Validating the value of option variable
	# taking actions based on chosen value
	if [[ $option =~ [1-9]|[x] && $option -lt 10 ]]
	then
		# calling check function to check if the option value is equal to 'x'
		check $option
		
		if [ $option -eq 1 ]
		then
			# calling addUser function to add a new user
			addUser

		elif [ $option -eq 2 ]
		then
			# calling addGroup function add a new group
			addGroup

		elif [ $option -eq 3 ]
		then
			# calling editUser function to edit the specified user
			editUser

		elif [ $option -eq 4 ]
		then
			# calling editGroup function to edit the specified group
			editGroup

		elif [ $option -eq 5 ]
		then
			# calling deleteUser function to delete the specified user
			deleteUser

		elif [ $option -eq 6 ]
		then
			# calling deleteGroup function to delete the specified group
			deleteGroup
		
		elif [ $option -eq 7 ]
		then
			# calling viewUsers function to view all the users in the system
			viewUsers

		elif [ $option -eq 8 ]
		then
			# calling viewGroups function to view all the groups in the system
			viewGroups

		elif [ $option -eq 9 ]
		then
			# calling viewGroupUsers function to view all the users in a group
			viewGroupUsers
		fi
	
	else 	
		# Rerunning the userManager similar to restarting the program
		userManager
	fi
}

# Creating reRun function to ask the user if he/she wants to rerun the program
# and taking actions based on chosen option
reRunUser(){
	# Modifying position variable to adjust text position
	successX=`echo "$successX+1" | bc -l`
	tput cup $successX 20
	tput bold
	tput setaf 4

	# reading the choosen option in read variable
	read -p "Do You Want To Continue With The Program[y/n] ? " action
	tput sgr0	

	# restarting the program if user chooses 'y'
	if [ $action = y ]
	then
		# callinfg userManager function if user selects to be in the program
		userManager
	else
		# Getting the file name of current file and re-executing
		./$(basename $0)
	fi
}

# Adjusting text position to greet and show menu at the start of the program
tput cup 2 20
tput rev
tput bold
echo " WELCOME TO LINUSMAN "
tput sgr0

# Displaying initial options to choose from at the start of the program
tput cup 6 20 
echo 1. Enter User Management Console
tput cup 7 20 
echo x To Exit From Anywhere

tput bold 
tput setaf 4
tput cup 9 20 
# Reading the choosen option value in the variable option
read -p "Enter Your Choice: " option 
tput sgr0

# Validating the value of option variable
# taking actions based on chosen value
if [[ $option =~ [1]|[x] && $option -lt 2 ]]
then
	# calling check function to check if the option value is equal to 'x'
	check $option

	if [ $option -eq 1 ]
	then
		clear
		# Checking if user is root
		# if not prompting to login as root since this program requires root permissions
		if [[ $EUID -ne 0 ]] 
		then
			# declaring and defining checked variable to store the status of root check
			checked=1
			tput cup 0
			tput setaf 1
			tput bold
			# showing message to login as root
			printf "This Program needs root privileges to run.\nPlease login as root and re-run the program.\n\n"
			tput sgr0
			tput setaf 2
			sudo su
			tput sgr0
			clear
		else
			# calling userManager function
			userManager
		fi
	fi
else 	
	clear    
	# Getting the file name of current file and re-executing if error occurs
	./$(basename $0)
fi

