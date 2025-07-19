require 'spec_helper'

require 'bot_box/command'

RSpec.describe BotBox::Command do

  describe '#initialize' do
    context 'with simple commands' do
      it 'creates valid MOVE command' do
        command = described_class.new("MOVE")
        
        expect(command.is_valid).to be true
        expect(command.command_type).to eq("MOVE")
        expect(command.args).to be_nil
      end

      it 'creates valid LEFT command' do
        command = described_class.new("LEFT")
        
        expect(command.is_valid).to be true
        expect(command.command_type).to eq("LEFT")
        expect(command.args).to be_nil
      end

      it 'creates valid RIGHT command' do
        command = described_class.new("RIGHT")
        
        expect(command.is_valid).to be true
        expect(command.command_type).to eq("RIGHT")
        expect(command.args).to be_nil
      end

      it 'creates valid REPORT command' do
        command = described_class.new("REPORT")
        
        expect(command.is_valid).to be true
        expect(command.command_type).to eq("REPORT")
        expect(command.args).to be_nil
      end
    end

    context 'with PLACE commands' do
      it 'creates valid PLACE command with coordinates and direction' do
        command = described_class.new("PLACE 1,2,NORTH")
        
        expect(command.is_valid).to be true
        expect(command.command_type).to eq("PLACE")
        expect(command.args).to eq([1, 2, "NORTH"])
      end

      it 'creates valid PLACE command with zero coordinates' do
        command = described_class.new("PLACE 0,0,SOUTH")
        
        expect(command.is_valid).to be true
        expect(command.command_type).to eq("PLACE")
        expect(command.args).to eq([0, 0, "SOUTH"])
      end

      it 'creates valid PLACE command with different directions' do
        directions = ["NORTH", "SOUTH", "EAST", "WEST"]
        
        directions.each do |direction|
          command = described_class.new("PLACE 3,4,#{direction}")
          
          expect(command.is_valid).to be true
          expect(command.command_type).to eq("PLACE")
          expect(command.args).to eq([3, 4, direction])
        end
      end

      it 'handles PLACE command with extra spaces' do
        command = described_class.new("PLACE  1,  2,  NORTH  ")
        
        expect(command.is_valid).to be true
        expect(command.command_type).to eq("PLACE")
        expect(command.args).to eq([1, 2, "NORTH"])
      end
    end

    context 'with invalid commands' do
      it 'marks invalid simple commands as invalid' do
        invalid_commands = ["MOV", "LEF", "RIGH", "REPOR", "JUMP", "SWIVEL"]
        
        invalid_commands.each do |cmd|
          command = described_class.new(cmd)
          expect(command.is_valid).to be false
          expect(command.command_type).to be_nil
          expect(command.args).to be_nil
        end
      end

      it 'marks PLACE commands with invalid coordinates as invalid' do
        invalid_place_commands = [
          "PLACE a,2,NORTH",    # non-numeric x
          "PLACE 1,b,NORTH",    # non-numeric y
          "PLACE -1,2,NORTH",   # negative x
          "PLACE 1,-2,NORTH",   # negative y
          "PLACE 1.5,2,NORTH",  # decimal x
          "PLACE 1,2.5,NORTH"   # decimal y
        ]
        
        invalid_place_commands.each do |cmd|
          command = described_class.new(cmd)
          expect(command.is_valid).to be false
          expect(command.command_type).to be_nil
          expect(command.args).to be_nil
        end
      end

      it 'marks PLACE commands with invalid directions as invalid' do
        invalid_directions = ["NOURTH", "SOUUTH", "EASTT", "WESTT", "UP", "DOWN", "LEFT", "RIGHT"]
        
        invalid_directions.each do |direction|
          command = described_class.new("PLACE 1,2,#{direction}")
          expect(command.is_valid).to be false
          expect(command.command_type).to be_nil
          expect(command.args).to be_nil
        end
      end

      it 'marks PLACE commands with wrong number of arguments as invalid' do
        invalid_place_commands = [
          "PLACE 1,NORTH",           # missing y coordinate
          "PLACE 1,2",               # missing direction
          "PLACE 1,2,NORTH,EXTRA",   # extra argument
          "PLACE",                   # no arguments
          "PLACE 1",                 # only x coordinate
          "PLACE 1,2,3,4"           # too many arguments
        ]
        
        invalid_place_commands.each do |cmd|
          command = described_class.new(cmd)
          expect(command.is_valid).to be false
          expect(command.command_type).to be_nil
          expect(command.args).to be_nil
        end
      end

      it 'marks commands that start with PLACE but are malformed as invalid' do
        invalid_commands = [
          "PLACEX 1,2,NORTH",    # wrong prefix
          "PLACE1,2,NORTH",      # no space after PLACE
          "PLACE 1;2;NORTH",     # wrong separator
          "PLACE 1 2 NORTH"      # wrong separator
        ]
        
        invalid_commands.each do |cmd|
          command = described_class.new(cmd)
          expect(command.is_valid).to be false
          expect(command.command_type).to be_nil
          expect(command.args).to be_nil
        end
      end
    end

    context 'with edge cases' do
      it 'handles empty string' do
        command = described_class.new("")
        
        expect(command.is_valid).to be false
        expect(command.command_type).to be_nil
        expect(command.args).to be_nil
      end

      it 'handles nil input' do
        command = described_class.new(nil)
        
        expect(command.is_valid).to be false
        expect(command.command_type).to be_nil
        expect(command.args).to be_nil
      end

      it 'handles whitespace-only input' do
        command = described_class.new("   \n  \t  ")
        
        expect(command.is_valid).to be false
        expect(command.command_type).to be_nil
        expect(command.args).to be_nil
      end

      it 'handles case sensitivity' do
        case_variations = ["move", "Move", "MOVE", "Move", "mOvE"]
        
        case_variations.each_with_index do |cmd, index|
          command = described_class.new(cmd)
          if index == 2  # "MOVE" should be valid
            expect(command.is_valid).to be true
            expect(command.command_type).to eq("MOVE")
          else
            expect(command.is_valid).to be false
            expect(command.command_type).to be_nil
          end
        end
      end
    end
  end

  describe 'command validation' do
    it 'validates non-negative integers correctly' do
      command = described_class.new("PLACE 0,0,NORTH")
      expect(command.is_valid).to be true
      
      command = described_class.new("PLACE 1,2,NORTH")
      expect(command.is_valid).to be true
      
      command = described_class.new("PLACE -1,2,NORTH")
      expect(command.is_valid).to be false
      
      command = described_class.new("PLACE 1,-2,NORTH")
      expect(command.is_valid).to be false
    end

    it 'validates directions correctly' do
      valid_directions = ["NORTH", "SOUTH", "EAST", "WEST"]
      
      valid_directions.each do |direction|
        command = described_class.new("PLACE 1,2,#{direction}")
        expect(command.is_valid).to be true
        expect(command.args[2]).to eq(direction)
      end
    end
  end
end
