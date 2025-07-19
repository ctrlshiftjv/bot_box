# spec/bot_box/command_file_spec.rb

require 'spec_helper'
require 'tempfile'

require 'bot_box/command_file'

RSpec.describe BotBox::CommandFile do

  let(:valid_command_file) { 'spec/fixtures/valid_command' }

  describe '#initialize' do
    context 'with a valid command file' do
      it 'creates a command file instance' do
        command_file = described_class.new(valid_command_file)
        expect(command_file).to be_a(described_class)
      end

      it 'sets the command file path' do
        command_file = described_class.new(valid_command_file)
        expect(command_file.command_file).to eq(valid_command_file)
      end

      it 'parses commands from the file' do
        command_file = described_class.new(valid_command_file)
        expect(command_file.commands).to be_an(Array)
        expect(command_file.commands).not_to be_empty
      end
    end
  end

  describe '#commands' do
    it 'returns an array of command strings' do
      command_file = described_class.new(valid_command_file)
      expect(command_file.commands).to be_an(Array)
      expect(command_file.commands.all? { |cmd| cmd.is_a?(String) }).to be true
    end

    it 'strips whitespace from command lines' do
      # Create a temporary file with whitespace
      temp_file = Tempfile.new(['test_commands', ''])
      temp_file.write("  PLACE 1,2,EAST  \n")
      temp_file.write("MOVE\n")
      temp_file.write("  LEFT  \n")
      temp_file.close

      command_file = described_class.new(temp_file.path)
      expect(command_file.commands).to eq(['PLACE 1,2,EAST', 'MOVE', 'LEFT'])

      temp_file.unlink
    end

    it 'skips empty lines' do
      # Create a temporary file with empty lines
      temp_file = Tempfile.new(['test_commands', ''])
      temp_file.write("PLACE 1,2,EAST\n")
      temp_file.write("\n")
      temp_file.write("MOVE\n")
      temp_file.write("  \n")
      temp_file.write("LEFT\n")
      temp_file.close

      command_file = described_class.new(temp_file.path)
      expect(command_file.commands).to eq(['PLACE 1,2,EAST', 'MOVE', 'LEFT'])

      temp_file.unlink
    end
  end

  describe 'validation' do
    context 'when command file is nil' do
      it 'raises an ArgumentError' do
        expect { described_class.new(nil) }.to raise_error(ArgumentError, 'Command file is required')
      end
    end

    context 'when command file does not exist' do
      it 'raises an ArgumentError' do
        expect { described_class.new('nonexistent_file') }.to raise_error(ArgumentError, 'Command file does not exist')
      end
    end

    context 'when command file is not readable' do
      it 'raises an ArgumentError' do
        # Create a file and make it unreadable
        temp_file = Tempfile.new(['test_commands', ''])
        temp_file.write("PLACE 1,2,EAST\n")
        temp_file.close
        File.chmod(0o000, temp_file.path)

        expect { described_class.new(temp_file.path) }.to raise_error(ArgumentError, 'Command file is not readable')

        # Clean up
        File.chmod(0o644, temp_file.path)
        temp_file.unlink
      end
    end

    context 'when command file has an extension' do
      it 'raises an ArgumentError' do
        temp_file = Tempfile.new(['test_commands', '.txt'])
        temp_file.write("PLACE 1,2,EAST\n")
        temp_file.close

        expect { described_class.new(temp_file.path) }.to raise_error(ArgumentError, 'Command file type is not valid')

        temp_file.unlink
      end
    end

    context 'when command file is too large' do
      it 'raises an ArgumentError' do
        # Create a file larger than MAX_FILE_SIZE
        temp_file = Tempfile.new(['test_commands', ''])
        large_content = 'A' * (BotBox::MAX_FILE_SIZE + 1)
        temp_file.write(large_content)
        temp_file.close

        expect { described_class.new(temp_file.path) }.to raise_error(ArgumentError, 'Command file size is too large')

        temp_file.unlink
      end
    end

    context 'when command file is not a plain text file' do
      it 'raises an ArgumentError' do
        # Create a binary file
        temp_file = Tempfile.new(['test_commands', ''])
        temp_file.binmode
        temp_file.write([0x89, 0x50, 0x4E, 0x47].pack('C*')) # PNG header
        temp_file.close

        expect { described_class.new(temp_file.path) }.to raise_error(ArgumentError, 'Command file must be a plain text file')

        temp_file.unlink
      end
    end
  end
end
