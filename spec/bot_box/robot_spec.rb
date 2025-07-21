require 'spec_helper'

require 'bot_box/robot'

RSpec.describe BotBox::Robot do
  let(:table_top) { BotBox::TableTop.new(length: 5, width: 5) }
  let(:robot) { described_class.new(table_top: table_top) }
  let(:command_file) { BotBox::CommandFile.new('spec/fixtures/valid_command') }

  describe '#initialize' do
    it 'creates robot with table top and command file' do
      expect(robot.table_top).to eq(table_top)
      expect(robot.placed).to be false
      expect(robot.x).to be_nil
      expect(robot.y).to be_nil
      expect(robot.f).to be_nil
    end
  end

  describe '#place' do
    it 'places robot at valid position' do
      robot.place(1, 2, BotBox::NORTH)
      
      expect(robot.x).to eq(1)
      expect(robot.y).to eq(2)
      expect(robot.f).to eq(BotBox::NORTH)
      expect(robot.placed).to be true
    end

    it 'ignores invalid position' do
      robot.place(-1, 2, BotBox::NORTH)
      
      expect(robot.x).to be_nil
      expect(robot.y).to be_nil
      expect(robot.f).to be_nil
      expect(robot.placed).to be false
    end
  end

  describe '#move' do
    it 'moves north' do
      robot.place(2, 2, BotBox::NORTH)
      robot.move

      expect(robot.x).to eq(2)
      expect(robot.y).to eq(3)
    end

    it 'moves south' do
      robot.place(2, 2, BotBox::SOUTH)
      robot.move

      expect(robot.x).to eq(2)
      expect(robot.y).to eq(1)
    end

    it 'moves east' do
      robot.place(2, 2, BotBox::EAST)
      robot.move

      expect(robot.x).to eq(3)
      expect(robot.y).to eq(2)
    end

    it 'moves west' do
      robot.place(2, 2, BotBox::WEST)
      robot.move

      expect(robot.x).to eq(1)
      expect(robot.y).to eq(2)
    end

    it 'ignores move at boundaries' do
      max_x = table_top.length - 1
      max_y = table_top.width - 1

      # We test the bounderies in WEST by traversing the left most, and going north ward.
      (0...max_y).each do |y|
        robot.place(0, y, BotBox::WEST)
        robot.move

        expect(robot.x).to eq(0)
        expect(robot.y).to eq(y)
      end

      # We test the bounderies in NORTH by traversing from the top most, and going west ward.
      (0...max_x).each do |x|
        robot.place(x, max_y, BotBox::NORTH)
        robot.move

        expect(robot.x).to eq(x)
        expect(robot.y).to eq(max_y)
      end

      # We test the bounderies in EAST by traversing from the right most, and going north ward.
      (0...max_y).each do |y|
        robot.place(max_x, y, BotBox::EAST)
        robot.move

        expect(robot.x).to eq(max_x)
        expect(robot.y).to eq(y)
      end

      # We test the bounderies in SOUTH by traversing from the bottom most, and going east ward.
      (0...max_x).each do |x|
        robot.place(x, 0, BotBox::SOUTH)
        robot.move

        expect(robot.x).to eq(x)
        expect(robot.y).to eq(0)
      end
    end
  end

  describe '#flip' do
  it 'flips from north to south' do
    robot.place(0, 0, BotBox::NORTH)
    robot.flip

    expect(robot.f).to eq(BotBox::SOUTH)
  end

  it 'flips from south to north' do
    robot.place(0, 0, BotBox::SOUTH)
    robot.flip

    expect(robot.f).to eq(BotBox::NORTH)
  end

  it 'flips from east to west' do
    robot.place(0, 0, BotBox::EAST)
    robot.flip

    expect(robot.f).to eq(BotBox::WEST)
  end

  it 'flips from west to east' do
    robot.place(0, 0, BotBox::WEST)
    robot.flip

    expect(robot.f).to eq(BotBox::EAST)
  end
end

  describe '#turn_left' do
    it 'turns left from north to west' do
      robot.place(0, 0, BotBox::NORTH)
      robot.turn_left

      expect(robot.f).to eq(BotBox::WEST)
    end

    it 'turns left from west to south' do
      robot.place(0, 0, BotBox::WEST)
      robot.turn_left

      expect(robot.f).to eq(BotBox::SOUTH)
    end

    it 'turns left from south to east' do
      robot.place(0, 0, BotBox::SOUTH)
      robot.turn_left

      expect(robot.f).to eq(BotBox::EAST)
    end

    it 'turns left from east to north' do
      robot.place(0, 0, BotBox::EAST)
      robot.turn_left

      expect(robot.f).to eq(BotBox::NORTH)
    end
  end

  describe '#turn_right' do
    it 'turns right from north to east' do
      robot.place(0, 0, BotBox::NORTH)
      robot.turn_right

      expect(robot.f).to eq(BotBox::EAST)
    end

    it 'turns right from east to south' do
      robot.place(0, 0, BotBox::EAST)
      robot.turn_right

      expect(robot.f).to eq(BotBox::SOUTH)
    end

    it 'turns right from south to west' do
      robot.place(0, 0, BotBox::SOUTH)
      robot.turn_right
      
      expect(robot.f).to eq(BotBox::WEST)
    end

    it 'turns right from west to north' do
      robot.place(0, 0, BotBox::WEST)
      robot.turn_right

      expect(robot.f).to eq(BotBox::NORTH)
    end
  end

  describe '#report' do
    it 'returns current position' do
      robot.place(3, 4, BotBox::EAST)
      expect(robot.report).to eq([3, 4, BotBox::EAST])
    end
  end

  describe '#execute_commands' do
    it 'executes commands from file' do
      robot.execute_commands(command_file.commands)
      expect(robot.placed).to be true
    end

    it 'handles file with no valid commands' do
      command_file = BotBox::CommandFile.new('spec/fixtures/no_valid_command')

      robot_no_valid = described_class.new(table_top: table_top)
      robot_no_valid.execute_commands(command_file.commands)

      expect(robot_no_valid.placed).to be false
    end

    it 'handles file with mix of valid and invalid commands' do
      command_file = BotBox::CommandFile.new('spec/fixtures/mix_command')

      robot_mix = described_class.new(table_top: table_top)
      robot_mix.execute_commands(command_file.commands)

      expect(robot_mix.placed).to be true
      expect(robot_mix.report).to eq([4, 4, BotBox::EAST])
    end
  end
end
