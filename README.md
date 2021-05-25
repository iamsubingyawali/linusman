# linusman
Shell script to manage users and groups, and atuomate backups in Linux. 

## Dependencies

The script depends on some linux packages which you need to install before you run the script. Use your package manager to install the following packages:

1. zenity
2. bc (Basic Calculator)
3. notify-send

## Run

To run the script simply clone this repo using the commend below in your Linux terminal.

```
git clone https://github.com/iamsubingyawali/linusman.git
```

Navigate to the script directory and run the file using commands below. You may need to change the permissions for the file to run, use **chmod** accordingly.

```
cd linusman
./manage.sh
```

## What does this script do?

The scipt has two main sections. 

![image](https://user-images.githubusercontent.com/45819206/119443791-ec522200-bd49-11eb-9712-06f076d5a38e.png)

One is Archive management section where you can set up archives and automate backups of your files and folders using cron jobs. 

Another section is user management section which can be used to manage users and groups in the system. User and groups management include adding, deleting, renaming, changing permissions and many more.

Full documentation for the usage of the scirpt will be published soon.

_Note: I am not responsible for any damange caused to your system with incorrect use of this script. Do not proceed with any options in the script unless you know what you are doing. Distributing your own copy of this script is not allowed. Read the license file carefully before proceeding._

_Bugs are expected. Open issues if you found some._
