
desc 'run the bot box'
task 'bot_box' do
  $LOAD_PATH.unshift(File.dirname(__FILE__), 'lib')

  require "bot_box"

  command_file = ENV["command_file"]
  board_size = ENV["board_size"] || "5,5"
  log_level = ENV["log_level"] || Logger::INFO

  BotBox.run(
    command_file: command_file, 
    board_size: board_size,
    log_level: log_level
  )
end