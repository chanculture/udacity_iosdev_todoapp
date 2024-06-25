# Swift Project: 
Todo App This project is for Udacity's iOS Developer nano-Degree. 
It is the project for Course 2, called "Todo App". It is a Command Line Interface (CLI) project where the user can interact with the CLI to create, toggle completed, delete, and list "todo" tasks.  The user can also explicitly save the todo list.

# Version
1.0 - Completed Project

# Usage:
When the program is run for the first time, it will attempt to load a file named "todo.json" from the user's downloads folder.  Therefore if the user's downloads folder is missing, or the program does not have access to this folder then the app will not load a file and/or subsequent saves to this folder for data persistence will fail.

## Commands:
Commands must be spelled correctly, but the app ignore alphabet lettercase and whitespace.

### Add: 
When the command "add" is typed, there will be a subsequent prompt to enter a "todo description".

### List: 
When the command "list" is typed, each todo previously entered using the "add" function will be listed with a numeric identifer prefixed to the beginning, as well as "completed: ❌" or "completed: ✅" depending if the todo has been marked as completed.

### Toggle: 
When the command "toggle" is types, there will be a subsequent prompt to enter the numeric id of which todo task to toggle.  The user mark a todo as completed or incomplete.

### Delete: 
When the command "delete" is typed, there will be a subsequent prompt to enter the numeric id of which todo task to delete, after the list is displayed to remind the user what todos already exist.

### Exit:
When the command "exit" is typed, the CLI App will exit, and return the user to the OS CLI

### Save:
In order for the todo list to persist between App Launch sessions, the user must use the "save" command.  This will attempt to write an encoded JSON file to the user's downloads directory.  If this directory does not exist or the user does not hve access to the folder, this function will not complete, and the todo list data will not persist to the next app session. 

### All other commands:
When on the Todo App's main command prompt, all other commands are ignored other than the listed ones above.



## Important Details:
1. As noted above, the user must explicitly use the "save" command to attempt to save data to disk for use on the next app launch.  This command will have the current todo list.


## Notes to the reviewer/grader:
1. Resources on how to build, as well as best practices for unit testing would be highly appreciated.  I could not figure out how to do this elegantlt for this CLI project.  Many thanks.




