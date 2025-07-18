
desc 'run the bot box'
task 'bot_box' do
  $LOAD_PATH.unshift(File.dirname(__FILE__), 'lib')

  require "bot_box"

  command_file = ENV["command_file"]
  board_size = ENV["board_size"] || 5

  BotBox.run(
    command_file: command_file, 
    board_size: board_size
  )
end