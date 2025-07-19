require 'spec_helper'

require 'bot_box/commander'

RSpec.describe BotBox::Commander do

  let(:valid_command_file) { 'spec/fixtures/valid_command' }
  let(:invalid_command_file) { 'spec/fixtures/invalid_command' }
  let(:mix_command_file) { 'spec/fixtures/mix_command' }

  describe 'Command struct' do
    it 'creates commands with correct structure' do
      command = BotBox::Command.new(BotBox::MOVE)
      expect(command.command_type).to eq(BotBox::MOVE)
      expect(command.args).to be_nil
      
      command_with_args = BotBox::Command.new(BotBox::PLACE, [1, 2, 'NORTH'])

      expect(command_with_args.command_type).to eq(BotBox::PLACE)
      expect(command_with_args.args).to eq([1, 2, 'NORTH'])
    end
  end

  describe '#initialize' do
    context 'with a command file with ALL valid commands' do
      it 'creates a commander with parsed commands' do
        commander = described_class.new(valid_command_file)
        
        expect(commander.command_file).to eq(valid_command_file)
        expect(commander.commands).to be_an(Array)
        expect(commander.commands.length).to eq(5)
      end

      it 'parses PLACE command correctly' do
        commander = described_class.new(valid_command_file)
        place_command = commander.commands.first
        
        expect(place_command.command_type).to eq(BotBox::PLACE)
        expect(place_command.args).to eq([1, 2, 'EAST'])
      end

      it 'parses simple commands correctly' do
        commander = described_class.new(valid_command_file)
        
        expect(commander.commands[1].command_type).to eq(BotBox::MOVE)
        expect(commander.commands[1].args).to be_nil
        
        expect(commander.commands[2].command_type).to eq(BotBox::LEFT)
        expect(commander.commands[2].args).to be_nil
        
        expect(commander.commands[3].command_type).to eq(BotBox::RIGHT)
        expect(commander.commands[3].args).to be_nil
        
        expect(commander.commands[4].command_type).to eq(BotBox::REPORT)
        expect(commander.commands[4].args).to be_nil
      end
    end

    context 'with invalid command file' do
      it 'raises ArgumentError when command file is nil' do
        expect { described_class.new(nil) }.to raise_error(ArgumentError, 'Command file is required')
      end

      it 'raises ArgumentError when command file does not exist' do
        expect { described_class.new('nonexistent_file') }.to raise_error(ArgumentError, 'Command file does not exist')
      end

      it 'raises ArgumentError when command file is not a plain text file' do
        temp_file = 'temp_not_plain_text'
        File.open(temp_file, 'wb') { |f| f.write("\xFF\xFE\xFA\xFB".b) }

        expect { described_class.new(temp_file) }.to raise_error(ArgumentError, 'Command file must be a plain text file')
        File.delete(temp_file)
      end

      it 'raises ArgumentError when command file type is not valid' do
        temp_file = 'temp_not_valid.txt'
        File.write(temp_file, "This is not a valid file")

        expect { described_class.new(temp_file) }.to raise_error(ArgumentError, 'Command file type is not valid')
        File.delete(temp_file)
      end
    end
  end

  describe 'command parsing' do
    context 'with edge cases' do
      it 'handles single command file' do
        temp_file = 'temp_single'
        File.write(temp_file, "PLACE 0,0,NORTH")
        commander = described_class.new(temp_file)
        
        expect(commander.commands.length).to eq(1)
        expect(commander.commands.first.command_type).to eq(BotBox::PLACE)
        
        File.delete(temp_file)
      end

      it 'handles empty file' do
        temp_file = 'temp_empty'
        File.write(temp_file, "")
        commander = described_class.new(temp_file)
        
        expect(commander.commands).to be_empty
        
        File.delete(temp_file)
      end

      it 'handles file with only whitespace' do
        temp_file = 'temp_whitespace_only'
        File.write(temp_file, "   \n  \n  ")
        commander = described_class.new(temp_file)
        
        expect(commander.commands).to be_empty
        
        File.delete(temp_file)
      end
    end

    context 'with simple commands' do
      it 'parses simple commands; MOVE, LEFT, RIGHT, REPORT' do

        commands_content = <<~COMMANDS
          MOVE
          LEFT
          RIGHT
          REPORT
        COMMANDS

        # Create a temporary file for this specific test since we need multiple PLACE commands
        temp_file = 'temp_simple_commands'
        File.write(temp_file, commands_content)
        commander = described_class.new(temp_file)
        
        expect(commander.commands.length).to eq(4)
        expect(commander.commands[0].command_type).to eq(BotBox::MOVE)
        expect(commander.commands[1].command_type).to eq(BotBox::LEFT)
        expect(commander.commands[2].command_type).to eq(BotBox::RIGHT)
        expect(commander.commands[3].command_type).to eq(BotBox::REPORT)

        File.delete(temp_file)
      end

      it 'ignores whitespace and invalid commands' do
        commands_content = <<~COMMANDS
          MOVe
          LEFTa
          SWIVEL
          JUMP

          REPORT
        COMMANDS

        temp_file = 'temp_invalid_commands'
        File.write(temp_file, commands_content)
        commander = described_class.new(temp_file)

        expect(commander.commands.length).to eq(1)
        expect(commander.commands.first.command_type).to eq(BotBox::REPORT)

        File.delete(temp_file)
      end
    end

    context 'with PLACE commands' do
      it 'parses PLACE commands with different coordinates and directions' do

        commands_content = <<~COMMANDS
          PLACE 0,0,NORTH
          PLACE 5,5,SOUTH
          PLACE 2,3,EAST
          PLACE 1,4,WEST
        COMMANDS

        # Create a temporary file for this specific test since we need multiple PLACE commands
        temp_file = 'temp_place_commands'
        File.write(temp_file, commands_content)
        commander = described_class.new(temp_file)
        
        expect(commander.commands.length).to eq(4)
        expect(commander.commands[0].args).to eq([0, 0, 'NORTH'])
        expect(commander.commands[1].args).to eq([5, 5, 'SOUTH'])
        expect(commander.commands[2].args).to eq([2, 3, 'EAST'])
        expect(commander.commands[3].args).to eq([1, 4, 'WEST'])
        
        File.delete(temp_file)
      end

      it 'ignores non-numeric coordinates' do
        commands_content = <<~COMMANDS
          PLACE 0,0,NORTH
          PLACE 5,5,SOUTH
          PLACE a,3,EAST
          PLACE 1,b,WEST
        COMMANDS

        temp_file = 'temp_invalid_place_commands'
        File.write(temp_file, commands_content)
        commander = described_class.new(temp_file)

        expect(commander.commands.length).to eq(2)
        expect(commander.commands[0].args).to eq([0, 0, 'NORTH'])
        expect(commander.commands[1].args).to eq([5, 5, 'SOUTH'])

        File.delete(temp_file)
      end

      it 'ignores invalid coordinates' do
        commands_content = <<~COMMANDS
          PLACE 0,0,NORTH
          PLACE -5,5,SOUTH
          PLACE 2,-3,EAST
        COMMANDS

        temp_file = 'temp_invalid_place_commands'
        File.write(temp_file, commands_content)
        commander = described_class.new(temp_file)

        expect(commander.commands.length).to eq(1)
        expect(commander.commands[0].args).to eq([0, 0, 'NORTH'])

        File.delete(temp_file)
      end

      it 'ignores invalid directions' do
        commands_content = <<~COMMANDS
          PLACE 0,0,NOURTH
          PLACE 5,5,SOUTH
          PLACE 2,3,WEAST
        COMMANDS

        temp_file = 'temp_invalid_place_commands'
        File.write(temp_file, commands_content)
        commander = described_class.new(temp_file)

        expect(commander.commands.length).to eq(1)
        expect(commander.commands[0].args).to eq([5, 5, 'SOUTH'])

        File.delete(temp_file)
      end

      it 'ignores wrong number of arguments' do
        wrong_arguments = [
          'PLACE 0,NORTH',
          'PLACE 0,0,NORTH,EXTRA',
          'PLACE',
          'PLACE 0,0'
        ]
        commands_content = <<~COMMANDS
          PLACE 0,NORTH
          PLACE 0,0,NORTH,EXTRA
          PLACE 0,0,NORTH,0
          PLACE
          PLACE 0,0
          PLACE 0,0,NORTH
        COMMANDS
        
        temp_file = "temp_wrong_args"
        File.write(temp_file, commands_content)
        commander = described_class.new(temp_file)
        
        expect(commander.commands.length).to eq(1)
        expect(commander.commands[0].args).to eq([0, 0, 'NORTH'])
        
        File.delete(temp_file)
      end
    end
  end
end
