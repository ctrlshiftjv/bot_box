
# Bot Box

A Ruby implementation of a Toy Robot simulation. The robot moves on a square tabletop and responds to commands like PLACE, MOVE, LEFT, RIGHT, and REPORT.

## Features
- Robot simulation on a configurable tabletop
- Command file processing
- Position validation (prevents robot from falling off the table)
- Direction control (NORTH, SOUTH, EAST, WEST)
- Movement and rotation commands

## Installation
```bash
bundle install
```

## Usage
The most direct way to start the application is by running:
```
rake bot_box
```
This will start the application in `listen` mode. You will be able to input your commands in the console to control the robot in real time.

Alternatively, you can also provide a file containing a list of commands that you would like to perfom like so.
```bash
rake bot_box run_type=file command_file=commands/forward
```

For a full list of arguments:

| Argument | Type | Required | Default | Description |
|----------|------|----------|---------|-------------|
| `run_type` | String | No | listen | One of the following - listen, file |
| `command_file` | String | Yes (file) | - | Path to the command file |
| `board_size` | String | No | `5,5` | L,W format where L and W are positive integers excluding zero |
| `log_level` | String | No | `unknown` | One of: debug, info, warn, error, fatal, unknown |

### Run Types
* **listen** - the program listens to the input and perform as you input.
* **file** - the program performs the commands that is contained in the file provided.

### Command Format
Commands are read from a file with one command per line:
- `PLACE X,Y,F` - Place robot at coordinates (X,Y) facing direction F
- `MOVE` - Move robot one unit forward
- `LEFT` - Turn robot 90° left
- `RIGHT` - Turn robot 90° right  
- `REPORT` - Output current position and direction

### Example Commands
```
PLACE 0,0,NORTH
MOVE
REPORT
```
Output: `0,1,NORTH`

## Sample Command Files
- `commands/forward` - Basic forward movement
- `commands/turn` - Sample Rotation command
- `commands/circular` - Circular movement pattern
- `commands/northernmost` - Movement to northern edge

## Testing
```bash
bundle exec rspec
```

## Project Structure
```
lib/bot_box/      # Core robot simulation classes
commands/         # Example command files
spec/             # Test suite
docs/             # Requirements and documentation
```