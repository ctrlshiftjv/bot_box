# frozen_string_literal: true

require "logger"

require "bot_box/config"
require "bot_box/logger"

require "bot_box/command_file"
require "bot_box/command"
require "bot_box/robot"
require "bot_box/table_top"

module BotBox

  def self.run(run_type: nil, command_file: nil, board_size: nil, log_level: nil)
    BotBox.logger.level = get_with_default_log_level(log_level)
    BotBox.logger.info "#{BotBox::NAME} v#{BotBox::VERSION} booting..."

    run_type = get_run_type(run_type)
    if run_type == COMMAND_FILE
      run_command_file(command_file: command_file, board_size: board_size)
    else
      run_listen(board_size: board_size)
    end
  end

  # Runs the robot with the given command file and board size.
  #
  # @param command_file [String] - the path to the command file.
  # @param board_size [String] - the size of the board in the format of "length,width".
  #
  # @return [void]
  def self.run_command_file(command_file:, board_size:)
    BotBox.logger.info "Running a command file..."

    # Make sure that a command file is passed in.
    validate_command_file(command_file)

    # Make sure we validate the board size
    length, width = validate_board_size(board_size)

    table_top = TableTop.new(length: length, width: width)

    command_file = CommandFile.new(command_file)

    robot = Robot.new(table_top: table_top)
    robot.execute_commands(command_file.commands)
  end

  # Runs the robot in listen mode.
  #
  # The robot will listen for commands from the user and execute them.
  #
  # @param board_size [String] - the size of the board in the format of "length,width".
  #
  # @return [void]
  def self.run_listen(board_size:)
    BotBox.logger.info "Listening for commands..."

    # Make sure we validate the board size
    length, width = validate_board_size(board_size)

    table_top = TableTop.new(length: length, width: width)

    robot = Robot.new(table_top: table_top)

    puts "Input commands to the robot. Press Ctrl+C to exit."
    loop do
      command = $stdin.gets.chomp
      robot.execute(command)
    end
  end

  # Gets the run type.
  # If no run type is provided, the default is listen.
  # If the run type is invalid, an error is raised.
  #
  # @param run_type [String] - the run type.
  #
  # @return [String] - the run type.
  def self.get_run_type(run_type)
    return LISTEN if run_type.nil? || run_type.empty?

    return run_type if BotBox::RUN_TYPES.include?(run_type)

    raise ArgumentError, "Invalid run type: #{run_type}"
  end

  # Gets the safe log level.
  # If no log level is provided, the default is unknown.
  # Otherwise, the log level is returned.
  #
  # NOTE: We are using the default levels of Ruby's Logger.
  # https://ruby-doc.org/stdlib-3.3.3/libdoc/logger/rdoc/Logger.html#class-Logger-label-Log+Levels
  # If the log level is not valid, it will raise an error.
  #
  # @param log_level [String] - the log level.
  #
  # @return [String] - the safe log level.
  def self.get_with_default_log_level(log_level)
    log_level.nil? ? ::Logger::UNKNOWN : log_level
  end

  # Validates the board size.
  # If no board size is provided, the default is 5,5.
  # If the board size is invalid, an error is raised.
  #
  # @param board_size [String] - the size of the board in the format of "length,width".
  #
  # @return [Integer, Integer] - the board size.
  def self.validate_board_size(board_size)
    return [5, 5] if board_size.nil? || board_size.empty?

    result = board_size.split(",").map(&:to_i)
    if result.size != 2 || result[0].nil? || result[1].nil?
      raise ArgumentError, "Board size must be in the format of 'length,width'"
    end

    result
  end
  
  # Validates the command file.
  # If no command file is provided, an error is raised.
  #
  # @param command_file [String] - the path to the command file.
  #
  # @return [void]
  def self.validate_command_file(command_file)
    if command_file.nil? || command_file.empty?
      raise ArgumentError, "Command file is required."
    end
  end

  # Gets the logger.
  # This is just a wrapper around the Logger Module which we use a singleton for the app.
  #
  # @return [Logger] - the logger.
  def self.logger
    BotBox::Logger.logger
  end
end

# Gracefully exit the program when the user presses Ctrl+C
Signal.trap("INT") do
  puts "Exiting gracefully..."
  puts "Bye!"

  exit
end