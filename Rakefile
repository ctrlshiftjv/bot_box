
desc 'run the bot box'
task 'bot_box' do
  $LOAD_PATH.unshift(File.dirname(__FILE__), 'lib')

  require "bot_box"

  run_type = ENV["run_type"]
  command_file = ENV["command_file"]
  board_size = ENV["board_size"]
  log_level = ENV["log_level"]

  BotBox.run(
    run_type: run_type,
    command_file: command_file, 
    board_size: board_size,
    log_level: log_level
  )
end