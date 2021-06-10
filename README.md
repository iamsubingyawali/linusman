# linusman
Shell script to manage users and groups in Linux. 

<img src="https://user-images.githubusercontent.com/45819206/121498870-909bc000-c9fc-11eb-8719-8e0156a4c882.png" width=500>

## What does this script do?

The user management section can be used to manage users and groups in the system. User and groups management includes adding, deleting, renaming, changing permissions and many more. It doesn't require any technical knowledge to use.

<img src="https://user-images.githubusercontent.com/45819206/121499211-e40e0e00-c9fc-11eb-9fd7-43b4a25293dd.png" width=500>

A detailed user guide is available within the script file at the beginning of the script. Go through it if something seems confusing.

## Dependencies

The script depends on some linux packages which you need to install before you run the script. Use your system package manager to install the following packages:

1. zenity
2. bc (Basic Calculator)

For Debian based distros with apt, use the following command:

```
sudo apt-get install zenity bc
```

## Run

After all dependencies are installed, to run the script simply clone this repo using the commend below in your Linux terminal.

```
git clone https://github.com/iamsubingyawali/linusman.git
```

Navigate to the script directory and run the file using commands below. You may need to change the permissions for the file to run, use **chmod** accordingly.

```
cd linusman
./manage.sh
```

_Note: I am not responsible for any damange caused to your system with incorrect use of this script. Do not proceed with any options in the script unless you know what you are doing. Distributing your own copy of this script is not allowed. Read the license file carefully before proceeding._

_Bugs are expected. Open issues or pull requests if you found some._
