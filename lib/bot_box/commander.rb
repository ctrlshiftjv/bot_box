# frozen_string_literal: true

require "bot_box/config"

module BotBox

  # Command is a struct that contains the command type and the arguments
  #
  # command_type - the type of command
  # args - the arguments for the command
  #
  # Example:
  # command = Command.new(PLACE, [1, 2, "NORTH"])
  # command.command_type # => PLACE
  # command.args # => [1, 2, "NORTH"]
  #
  # command = Command.new(MOVE)
  # command.command_type # => MOVE
  # command.args # => nil
  Command = Struct.new(:command_type, :args)

  # Commander is a class that parses the command file and maintains a list of commands.
  # It validates the commands and returns a list of valid commands.
  #
  # NOTE: 
  #   - INVALID commands are ignored.
  #
  # WARNING: 
  #   - If the command file is NOT passed in, an ArgumentError will be raised.
  #   - If the command file is not found, an ArgumentError will be raised.
  #
  # Example:
  # commander = Commander.new("commands")
  # commander.commands # => [Command.new(PLACE, [1, 2, "NORTH"]), Command.new(MOVE)]
  #
  # @param command_file [String] - the file containing the commands to be executed by the robot.
  # @param commands [Array] - the list of commands to be executed by the robot.
  class Commander

    attr_reader :command_file, :commands

    def initialize(command_file)
      @command_file = command_file
      @commands = parsed_instructions
    end

    private

    # Parse the command file and return a list of commands.
    def parsed_instructions
      validate_command_file
      
      commands = []
      line_number = 0
      
      File.foreach(command_file) do |line|
        line_number += 1
        line = line.strip
        
        # Skip empty lines
        next if line.empty?
        
        # Clean the command; if a valid command is found store it, otherwise ignore it.
        cleaned_command = clean_command(line)
        if cleaned_command
          commands << cleaned_command
        else
          BotBox.logger.debug "Ignored invalid command at line #{line_number}: #{line}"
        end
      end

      BotBox.logger.info "Successfully parsed #{commands.length} commands from #{command_file}"

      return commands
    end

    # Validate the command file before processing
    def validate_command_file
      raise ArgumentError, "Command file is required" if command_file.nil?
      raise ArgumentError, "Command file does not exist" unless File.exist?(command_file)
      raise ArgumentError, "Command file is not readable" unless File.readable?(command_file)
    end

    # Clean the command;
    # if command is a valid command, return a Command object.
    # if command is not a valid command, return nil.
    #
    # @param command [String] - the command to be cleaned
    # 
    # @return [Command] - a Command object if the command is valid, otherwise nil
    def clean_command(command)
      if [MOVE, LEFT, RIGHT, REPORT].include?(command)
        return Command.new(command)
      end
      
      if command.start_with?(PLACE)
        place_coordinates = get_place_coordinates(command)
        return Command.new(PLACE, place_coordinates) if place_coordinates
      end
      
      nil
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
      return unless command.include?(PLACE)

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
