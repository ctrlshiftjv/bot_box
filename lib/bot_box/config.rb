# frozen_string_literal: true

module BotBox

  NAME = "BotBox"
  VERSION = "0.0.1"
  MAX_FILE_SIZE = 1024 * 1024

  # Directions CONSTANTS
  NORTH = "NORTH"
  SOUTH = "SOUTH"
  EAST = "EAST"
  WEST = "WEST"

  DIRECTIONS = [
    NORTH,
    SOUTH,
    EAST,
    WEST
  ]

  # Command CONSTANTS
  PLACE = "PLACE"
  MOVE = "MOVE"
  FLIP = "FLIP"
  LEFT = "LEFT"
  RIGHT = "RIGHT"
  REPORT = "REPORT"

  # Run type CONSTANTS
  LISTEN = "listen"
  COMMAND_FILE = "file"

  RUN_TYPES = [
    LISTEN,
    COMMAND_FILE
  ]

end