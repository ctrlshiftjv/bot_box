# spec/bot_box_spec.rb
require "bot_box"

RSpec.describe BotBox do
  describe ".validate_board_size" do
    it "returns an array of integers when valid" do
      expect(BotBox.validate_board_size("5,5")).to eq([5, 5])
    end

    it "raises an error when format is invalid" do
      expect { BotBox.validate_board_size("5") }.to raise_error(ArgumentError, "Board size must be in the format of 'width,height'")
    end

    it "raises an error when input is empty" do
      expect { BotBox.validate_board_size("") }.to raise_error(ArgumentError, "Board size must be in the format of 'width,height'")
    end
  end

  describe ".validate_command_file" do
    it "does not raise an error when valid" do
      expect { BotBox.validate_command_file("commands.txt") }.not_to raise_error
    end

    it "raises an error when file is nil" do
      expect { BotBox.validate_command_file(nil) }.to raise_error(ArgumentError, "Command file is required")
    end

    it "raises an error when file is empty" do
      expect { BotBox.validate_command_file("") }.to raise_error(ArgumentError, "Command file is required")
    end
  end

  describe ".run" do
    let(:valid_command_file) { "commands.txt" }
    let(:valid_board_size) { "5,5" }

    it "initializes the TableTop with correct dimensions" do
      expect(BotBox::TableTop).to receive(:new).with(5, 5)
      BotBox.run(command_file: valid_command_file, board_size: valid_board_size)
    end

    it "raises an error when board size is invalid" do
      expect {
        BotBox.run(command_file: valid_command_file, board_size: "5")
      }.to raise_error("Board size must be in the format of 'width,height'")
    end

    it "raises an error when command file is missing" do
      expect {
        BotBox.run(command_file: nil, board_size: "5,5")
      }.to raise_error("Command file is required")
    end
  end
end
