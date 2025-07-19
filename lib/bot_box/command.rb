
# frozen_string_literal: true

require "bot_box/config"

module BotBox
  # Command is a struct that contains the command type and the arguments
  #
  # command_type - the type of command
  # args - the arguments for the command
  #
  # Example:
  # command = Command.new("PLACE 1,2,NORTH")
  # command.command_type # => PLACE
  # command.args # => [1, 2, "NORTH"]
  # command.is_valid # => true
  #
  # command = Command.new("MOVE")
  # command.command_type # => MOVE
  # command.args # => nil
  # command.is_valid # => true
  class Command

    attr_reader :is_valid, :command_type, :args

    def initialize(command_line)
      @is_valid = false
      @command_type = nil
      @args = nil

      clean_command(command_line)
    end

    private

    # Clean the command;
    # if command is a valid command, return a Command object.
    # if command is not a valid command, return nil.
    #
    # @param command [String] - the command to be cleaned
    def clean_command(command)
      return if command.nil? || command.empty?

      if [MOVE, LEFT, RIGHT, REPORT].include?(command)
        @is_valid = true
        @command_type = command
      end
      
      if command.start_with?(PLACE)
        place_coordinates = get_place_coordinates(command)

        if place_coordinates
          @is_valid = true
          @command_type = PLACE
          @args = place_coordinates
        end
      end
    end

    # Get the coordinates for the PLACE command. 
    # If the command is not a PLACE command, return nil.
    # If the command has invalid coordinates, return nil.
    #
    # VALID PLACE COMMAND must be in the format of:
    #   - "PLACE <x>,<y>,<direction>"
    #   - <x> and <y> must be non-negative integers
    #   - <direction> must be a valid direction
    #
    # EXAMPLE:
    #   - "PLACE 1,2,NORTH" => [1, 2, "NORTH"]
    #   - "PLACE 1,2,INVALID" => nil
    #   - "MOVE" => nil
    #
    # @param command [String] - the command to be cleaned
    #
    # @return [Array] - the coordinates for the PLACE command if the command is valid, otherwise nil
    def get_place_coordinates(command)
      place_coordinates = command.gsub("#{PLACE} ", "").split(",").map(&:strip)

      return unless place_coordinates.size == 3
      return unless valid_non_negative_integer? place_coordinates[0]
      return unless valid_non_negative_integer? place_coordinates[1]
      return unless valid_direction? place_coordinates[2]

      return [place_coordinates[0].to_i, place_coordinates[1].to_i, place_coordinates[2]]
    end

    # Check if the string is a valid non-negative integer.
    #
    # @param str [String] - the string to check
    #
    # @return [Boolean] - true if the string is a valid non-negative integer, otherwise false
    def valid_non_negative_integer?(str)
      return false if str.nil? || str.empty?
      
      Integer(str) >= 0
    rescue ArgumentError, TypeError
      false
    end

    # Check if the string is a valid direction.
    #
    # @param str [String] - the string to check
    #
    # @return [Boolean] - true if the string is a valid direction, otherwise false
    def valid_direction?(str)
      return false if str.nil? || str.empty?

      DIRECTIONS.include?(str)
    end

    
  end
end