# Bot Box
A Robot Simulator.

## Requirements
* The application simulates a toy robot moving on a 5x5 square tabletop.
* The robot can be controlled using the follwing commands:
* The PLACE command puts the robot at a position (X,Y,F) where F is direction the robots faces (NORTH, SOUTH, EAST, WEST)
* The origin (0,0) is the SOUTHWEST corner of the table.
* The first valid command MUST be a PLACE; all other commands are ignored until a valid PLACE is received.
* After a valid PLACE, any sequence of commands is allowed, including additional PLACE commands.
* The MOVE command moves the robot one unit forward in the direction it is currently facing. 
* The LEFT and RIGHT commands rotate the robot 90 degrees in the specified direction WITHOUT changing its position.
* The REPORT command outputs the robot's current X,Y,F 
* The Robot ignores MOVE, LEFT, RIGHT AND REPORT commandds if it is not on the table.
* The robot must not fall of the table at any time.
* Any command that wuold cause the robot to fall off the table including initial placement will be classified as invalid and will be ingored. 

## Assumptions
* Since invalid commands will be ignored. If no valid command was placed, this means that the Robot is not in the table and will output "204: No Robot found."

## Concept
In order to make sure that the Bot Box handles changing requirements, I have made it a tabletop-centric design. The relationship will most likely not be one robot in a multiple tabletop, but instead a tabletop may have multiple robots in the future. This way, it will be more open to changes in behavior.

## Enhancement
* The table top dimensions can be adjusted freely.
* A GUI can be called to see how the Robot moves.
* The number of Robots can be scaled.