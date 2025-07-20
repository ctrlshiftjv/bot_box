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

### Overview
On startup, the application creates a tabletop and a robot. The robot is made aware of the tabletop so that it can check and respect its boundaries during movement.

### Ways to Run the Simulation
You can run the simulation in two ways:

**Using a Command File**.
Provide a file containing commands (one per line). The application will:
* Validate the file
* Parse the commands into a list
* Make the Robot execute them in order

**Interactive Mode (Console Input)**
Run the program and enter commands directly via the console. The robot will process each command as you input them.

### Debug Mode
If you want to debug, you can start the program in a debug mode to see the steps the program is taking clearly.

## Entities
* TableTop - holds the information of its bounds.
* CommandFile - validates file and parses line by line
* Command - validates format of a command
* Robot - holds all logic on how to perform a command.

## Enhancement
* The table top dimensions can be adjusted freely.
* Added log levels for better debugging.
* Allow file mode to receive instructions from a file.
 