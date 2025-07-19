# spec/bot_box_spec.rb
require "bot_box"

RSpec.describe BotBox do

  describe ".run" do
    it "defaults to listen mode when run_type is nil" do
      expect(BotBox).to receive(:run_listen).with(board_size: "5,5")
      BotBox.run(run_type: nil, board_size: "5,5")
    end

    it "calls run_command_file when run_type is 'file'" do
      expect(BotBox).to receive(:run_command_file).with(command_file: "test", board_size: "5,5")
      BotBox.run(run_type: "file", command_file: "test", board_size: "5,5")
    end

    it "raises ArgumentError for invalid run_type" do
      expect {
        BotBox.run(run_type: "invalid")
      }.to raise_error(ArgumentError, "Invalid run type: invalid")
    end

    # TODO: Add more test.
  end

  describe ".validate_board_size" do
    it "returns default size [5, 5] when board_size is nil" do
      expect(BotBox.validate_board_size(nil)).to eq([5, 5])
    end

    it "returns parsed size for valid format" do
      expect(BotBox.validate_board_size("3,4")).to eq([3, 4])
    end

    it "raises ArgumentError for invalid format" do
      expect {
        BotBox.validate_board_size("invalid")
      }.to raise_error(ArgumentError, "Board size must be in the format of 'width,height'")
    end
  end

  describe ".validate_command_file" do
    it "raises ArgumentError when command_file is nil" do
      expect {
        BotBox.validate_command_file(nil)
      }.to raise_error(ArgumentError, "Command file is required.")
    end
  end
end
