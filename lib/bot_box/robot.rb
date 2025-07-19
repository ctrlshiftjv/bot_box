# frozen_string_literal: true

require "bot_box/config"

module BotBox
  # A smart robot that can move on a table top. It accepts a command file and executes the commands.
  # The robot can be placed on the table top, and it can move, turn left, turn right, and report its position.
  # 
  # @param table_top [TableTop] - the table top on which the robot may be placed.
  # @param command_file [String] - the file containing the commands to be executed by the robot.
  #
  # Example:
  # robot = Robot.new(table_top: table_top, command_file: "commands")
  # robot.simulate
  class Robot

    # table_top - the table top on which the robot may be placed.
    # command_file - the file containing the commands to be executed by the robot.
    attr_reader :table_top, :commander

    # placed - whether the robot is placed on the table top
    attr_reader :placed

    # x - position on the x-axis
    # y - position on the y-axis
    # f - direction of the robot
    attr_reader :x, :y, :f

    def initialize(table_top:, command_file:)
      @table_top = table_top
      @commander = Commander.new(command_file)

      @placed = false

      @x = nil
      @y = nil
      @f = nil
    end

    # Simulate the robot's behavior.
    #
    # Got through each command and perform the action.
    # The other commands are ignored, if the robot is not placed.
    def simulate
      commander.commands.each do |command|
        # puts "Command: #{command.command_type}"

        # Only perform the command, if the robot is placed or if the command is PLACE.
        next unless placed || command.command_type == PLACE

        case command.command_type
        when PLACE
          place(*command.args)
        when MOVE
          move
        when LEFT
          turn_left
        when RIGHT
          turn_right
        when REPORT
          report
        end
      end
    end

    # Place the robot on the table top.
    #
    # The robot will be placed on the table top, if the position is valid.
    #
    # @param x [Integer] - the x-coordinate of the robot.
    # @param y [Integer] - the y-coordinate of the robot.
    # @param f [Symbol] - the direction of the robot.
    def place(x,y,f)
      # puts "Placing robot at #{x},#{y},#{f}"

      # Check if the position is valid.
      unless valid_position?(x, y)
        # puts "Invalid position: #{x},#{y}"
        return
      end

      @x = x
      @y = y
      @f = f

      @placed = true

      # puts "Robot placed at #{x},#{y},#{f}"
    end

    # Move the robot one step forward in the direction it is facing.
    #
    # Before moving, the robot checks if the new position is valid.
    # If the new position is not valid, the robot does not move.
    def move
      # puts "Robot is moving..."

      new_x = @x
      new_y = @y

      case @f
      when NORTH
        new_y += 1
      when SOUTH
        new_y -= 1
      when EAST
        new_x += 1
      when WEST
        new_x -= 1
      end

      if valid_position?(new_x, new_y)
        @x = new_x
        @y = new_y

        # puts "Robot moved to #{x},#{y},#{f}"
      else
        # puts "Robot cannot move to #{new_x},#{new_y},#{f}"
      end
    end

    # Turn the robot 90 degrees to the left.
    #
    # The robot will turn left, if it is facing north, it will face west.
    # If it is facing west, it will face south.
    # If it is facing south, it will face east.
    # If it is facing east, it will face north.
    def turn_left
      # puts "Turning left from #{f}"

      case @f
      when NORTH
        @f = WEST
      when WEST
        @f = SOUTH
      when SOUTH
        @f = EAST
      when EAST
        @f = NORTH
      end
    end

    # Turn the robot 90 degrees to the right.
    #
    # The robot will turn right, if it is facing north, it will face east.
    # If it is facing east, it will face south.
    # If it is facing south, it will face west.
    # If it is facing west, it will face north.
    def turn_right
      # puts "Turning right from #{f}"

      case @f
      when NORTH
        @f = EAST
      when EAST
        @f = SOUTH
      when SOUTH
        @f = WEST
      when WEST
        @f = NORTH
      end
    end

    # Report the robot's position.
    #
    # @return [Array] - the robot's position.
    def report
      # puts "Reporting position: #{x},#{y},#{f}"

      [x,y,f]
    end

    private

    # Check if the position is valid.
    #
    # @param x [Integer] - the x-coordinate of the position.
    # @param y [Integer] - the y-coordinate of the position.
    #
    # @return [Boolean] - true if the position is valid, false otherwise.
    def valid_position?(new_x, new_y)
      return false if new_x.nil? || new_y.nil?
      return false if new_x < 0 || new_x >= table_top.length
      return false if new_y < 0 || new_y >= table_top.width

      true
    end

  end
end