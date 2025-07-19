
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
In order to start a simulation, you must pass a file using the argument `command_file` like so:
```bash
rake bot_box command_file=commands/forward
```

Alternatively, you can provide the size of the board with the optional argument `board_size`
```bash
rake bot_box command_file=commands/forward board_size=5,5
```

For a full list of arguments:
```
command_file [String] [required]
board_size [String] [optional] - Default: 5,5 - L,W format where L and W are positive integers excluding zero.
log_level [String] [option] - Default: unknown - One of the following: debug, info, warn, error, fatal, unknown
```

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