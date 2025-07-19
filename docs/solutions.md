# Bot Box
A Robot Simulator.

## Requirements
* The application simulates a toy robot moving on a 5x5 square tabletop.
* The robot can be controlled using the follwing commands:
    * PLACE X,Y,F
    * MOVE
    * LEFT
    * RIGHT
    * REPORT
* The PLACE command puts the robot at a position (X,Y,F) where F is direction the robots faces (NORTH, SOUTH, EAST, WEST)
* The origin (0,0) is the SOUTHWEST corner of the table.
* The first valid command MUST be a PLACE; all other commands are ignored until a valid PLACE is received.
* After a valid PLACE, any sequence of commands is allowed, including additional PLACE commands.
* The MOVE command moves the robot one unit forward in the direction it is currently facing. 
* The LEFT and RIGHT commands rotate the robot 90 degrees in the specified direction WITHOUT changing its position.
* The REPORT command outputs the robot's current X,Y,F 
* The Robot ignores MOVE, LEFT, RIGHT AND REPORT commandds if it is not on the table.
* The robot must not fall of the table at any time.
* Any command that would cause the robot to fall off the table including initial placement will be classified as invalid and will be ingored. 

## Concept
Just like in real life, the robot can receive a command file with a list of commands it needs to follow. Before it begins, it calls on the commander. The commander’s job is to look through the commands and get rid of anything that isn’t valid. This way, the robot only works with safe and proper instructions. After that, the robot goes through the list given by the commander. It is smart enough to check if a command will make it fall off the table and if it does, the robot simply ignore it.

## Entities
* TableTop - holds logic on the bounds.
* Commander - holds all valid commands.
* Command - a struct to hold a standardized format of a command.
* Robot - holds all logic on how to perform a command.

## Enhancement
* The table top dimensions can be adjusted freely.
* A GUI can be called to see how the Robot moves.
 