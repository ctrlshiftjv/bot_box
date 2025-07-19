
# puts "BotBox loading..."
require "logger"

require "bot_box/config"
require "bot_box/logger"

require "bot_box/command_file"
require "bot_box/command"
require "bot_box/table_top"
require "bot_box/robot"

# puts "BotBox loaded..."

module BotBox

  def self.run(command_file:, board_size:, log_level: ::Logger::UNKNOWN)
    BotBox.logger.level = log_level
    BotBox.logger.info "#{BotBox::NAME} v#{BotBox::VERSION} running..."

    # Make sure that a command file is passed in.
    validate_command_file(command_file)

    # Make sure we validate the board size
    length, width = validate_board_size(board_size)
  
    table_top = TableTop.new(length: length, width: width)

    command_file = CommandFile.new(command_file)

    robot = Robot.new(table_top: table_top)
    robot.execute_commands(command_file.commands)
  end

  def self.validate_board_size(board_size)
    result = board_size.split(",").map(&:to_i)
    if result.size != 2 || result[0].nil? || result[1].nil?
      raise ArgumentError, "Board size must be in the format of 'width,height'"
    end
    result
  end
  
  def self.validate_command_file(command_file)
    if command_file.nil? || command_file.empty?
      raise ArgumentError, "Command file is required"
    end
  end

  def self.logger
    BotBox::Logger.logger
  end
end
