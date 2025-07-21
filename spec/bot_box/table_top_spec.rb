require 'spec_helper'

require 'bot_box/table_top'

RSpec.describe BotBox::TableTop do
  let(:table) { described_class.new(length: 5, width: 5) }

  describe '#initialize' do
    it 'sets length and width' do
      table = described_class.new(length: 5, width: 5)

      expect(table.length).to eq(5)
      expect(table.width).to eq(5)
    end

    context 'with invalid parameters' do
      it 'raises ArgumentError when length is nil' do
        expect {
          described_class.new(length: nil, width: 5)
        }.to raise_error(ArgumentError, "Length and width must greater than zero.")
      end

      it 'raises ArgumentError when width is nil' do
        expect {
          described_class.new(length: 5, width: nil)
        }.to raise_error(ArgumentError, "Length and width must greater than zero.")
      end

      it 'raises ArgumentError when length is zero' do
        expect {
          described_class.new(length: 0, width: 5)
        }.to raise_error(ArgumentError, "Length and width must greater than zero.")
      end

      it 'raises ArgumentError when width is zero' do
        expect {
          described_class.new(length: 5, width: 0)
        }.to raise_error(ArgumentError, "Length and width must greater than zero.")
      end
    end
  end

  describe '#has_obstacles?' do
    let(:obstacle_class) { BotBox::TableTops::Obstacle }

    context 'when there are no obstacles' do
      let(:table) { described_class.new(length: 5, width: 5) }

      it 'returns false for any position' do
        expect(table.has_obstacles?(1, 1)).to be false
        expect(table.has_obstacles?(0, 0)).to be false
      end
    end

    context 'when there is an obstacle at the given position' do
      let(:obstacle) { obstacle_class.new(2, 3) }
      let(:table) { described_class.new(length: 5, width: 5, obstacles: [obstacle]) }

      it 'returns true for the obstacle position' do
        expect(table.has_obstacles?(2, 3)).to be true
      end

      it 'returns false for other positions' do
        expect(table.has_obstacles?(1, 1)).to be false
        expect(table.has_obstacles?(2, 2)).to be false
      end
    end

    context 'when there are multiple obstacles' do
      let(:obstacles) { [obstacle_class.new(0, 0), obstacle_class.new(4, 4)] }
      let(:table) { described_class.new(length: 5, width: 5, obstacles: obstacles) }

      it 'returns true for any position with an obstacle' do
        expect(table.has_obstacles?(0, 0)).to be true
        expect(table.has_obstacles?(4, 4)).to be true
      end

      it 'returns false for positions without obstacles' do
        expect(table.has_obstacles?(2, 2)).to be false
      end
    end
  end
end
