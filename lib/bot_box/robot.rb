# frozen_string_literal: true

require 'stringio'

require "bot_box/config"

module BotBox
  # A smart robot that can move on a table top. It accepts a command or a list of commands to execute.
  # The robot can be placed on the table top, and it can move, turn left, turn right, and report its position.
  # 
  # @param table_top [TableTop] - the table top on which the robot may be placed.
  #
  # Example:
  # robot = Robot.new(table_top: table_top)
  # robot.simulate
  class Robot

    # table_top [TableTop] - the table top on which the robot may be placed.
    attr_reader :table_top

    # placed [Boolean] - whether the robot is placed on the table top
    attr_reader :placed

    # x [Integer] - position on the x-axis (length)
    # y [Integer] - position on the y-axis (width)
    # f [String] - direction of the robot (NORTH, SOUTH, EAST, WEST)
    attr_reader :x, :y, :f

    def initialize(table_top:)
      @table_top = table_top

      @placed = false

      @x = nil
      @y = nil
      @f = nil
    end

    # Execute a list of commands.
    #
    # @param commands [Array] - the list of commands to execute.
    #
    # @return [void]
    def execute_commands(commands)
      commands.each do |command_line|
        execute(command_line)
      end
    end

    # Execute a single command.
    #
    # @param command_line [String] - the command to execute.
    #
    # @return [void]
    def execute(command_line)
      BotBox.logger.info "Executing command: #{command_line}"

      command = Command.new(command_line)
    
      unless command.is_valid
        BotBox.logger.warn "Invalid command: #{command_line}"
        return
      end

      BotBox.logger.info "Command: #{command.command_type}"

      case command.command_type
      when PLACE
        place(*command.args)
      when MOVE
        move
      when FLIP
        flip
      when LEFT
        turn_left
      when RIGHT
        turn_right
      when REPORT
        report
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
      BotBox.logger.info "Placing robot at #{x},#{y},#{f}"

      # Check if the position is valid.
      if valid_position?(x, y)
        @x = x
        @y = y
        @f = f

        @placed = true

        BotBox.logger.info "Robot placed at #{x},#{y},#{f}"
      else
        BotBox.logger.warn "Invalid position: #{x},#{y}"
      end
    end

    # Move the robot one step forward in the direction it is facing.
    #
    # If the robot is not placed, it can not move.
    #
    # Before moving, the robot checks if the new position is valid.
    # If the new position is not valid, the robot does not move.
    def move
      return unless robot_placed?

      BotBox.logger.info "Robot is moving..."

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

        BotBox.logger.info "Robot moved to #{x},#{y},#{f}"
      else
        BotBox.logger.warn "Robot cannot move to #{new_x},#{new_y},#{f}"
      end
    end

    # Turn the robot 180 degrees
    def flip
      return unless robot_placed?

      BotBox.logger.info "Turning flip from #{@f}"

      case @f
      when NORTH
        @f = SOUTH
      when SOUTH
        @f = NORTH
      when EAST
        @f = WEST
      when WEST
        @f = EAST
      end

      BotBox.logger.info "Turned flip to #{@f}"
    end

    # Turn the robot 90 degrees to the left.
    #
    # If the robot is not placed, it can not turn left.
    #
    # The robot will turn left, 
    # - if it is facing north, it will face west.
    # - If it is facing west, it will face south.
    # - If it is facing south, it will face east.
    # - If it is facing east, it will face north.
    #
    # @return [void]
    def turn_left
      return unless robot_placed?

      BotBox.logger.info "Turning left from #{@f}"

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

      BotBox.logger.info "Turned left to #{@f}"
    end

    # Turn the robot 90 degrees to the right.
    # 
    # If the robot is not placed, it can not turn right.
    #
    # The robot will turn right, 
    # - if it is facing north, it will face east.
    # - If it is facing east, it will face south.
    # - If it is facing south, it will face west.
    # - If it is facing west, it will face north.
    #
    # @return [void]
    def turn_right
      return unless robot_placed?

      BotBox.logger.info "Turning right from #{@f}"

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

      BotBox.logger.info "Turned right to #{@f}"
    end

    # Report the robot's position.
    #
    # If the robot is not placed, it can not report its position.
    #
    # @return [Array] - the robot's position.
    def report
      return unless robot_placed?

      BotBox.logger.info "Reporting: #{x},#{y},#{f}"

      # One of the requirement is to OUTPUT when report is called.
      puts "#{x},#{y},#{f}"

      # Show the Matrix Position of the Robot
      radar_layout_report

      [x,y,f]
    end

    private

    # Check if the robot is placed on the table top.
    # If not placed, log a warning and return false.
    #
    # @return [Boolean] - true if the robot is placed, false otherwise.
    def robot_placed?
      unless placed
        BotBox.logger.warn "Robot is not placed in the table top, ignoring command"
        return false
      end
      true
    end

    # Check if the position is valid.
    #
    # The position is valid if:
    # - The x-coordinate is greater than or equal to 0 and less than the length of the table top.
    # - The y-coordinate is greater than or equal to 0 and less than the width of the table top.
    # - The position does not have an obstacle.
    #
    # @param x [Integer] - the x-coordinate of the position.
    # @param y [Integer] - the y-coordinate of the position.
    #
    # @return [Boolean] - true if the position is valid, false otherwise.
    def valid_position?(new_x, new_y)
      return false if new_x.nil? || new_y.nil?
      return false if new_x < 0 || new_x >= table_top.length
      return false if new_y < 0 || new_y >= table_top.width
      return false if table_top.has_obstacles?(new_x, new_y)

      true
    end

    # View the position of the robot on the table top.
    #
    # This will direct output to the console how the robots sees the table top.
    # Each unit of the table top is represented by a dot.
    # The robot is represented by an 'x'.
    # The obstacle is represented by a 'o'.
    #
    # @return [void]
    def radar_layout_report
      max_x = table_top.length - 1
      max_y = table_top.width - 1
    
      output = StringIO.new
    
      max_y.downto(0) do |cy|
        0.upto(max_x) do |cx|
          if cx == x && cy == y
            output << " x "
          elsif table_top.has_obstacles?(cx, cy)
            output << " o "
          else
            output << " . "
          end
        end
        output << "\n"
      end

      puts output.string
    end
  end
end