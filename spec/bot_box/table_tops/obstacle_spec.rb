require 'spec_helper'
require 'bot_box/table_tops/obstacle'

RSpec.describe BotBox::TableTops::Obstacle do
  describe '#initialize' do
    it 'sets the x and y coordinates' do
      obstacle = described_class.new(3, 4)
      expect(obstacle.x).to eq(3)
      expect(obstacle.y).to eq(4)
    end
  end

  describe 'attribute readers' do
    let(:obstacle) { described_class.new(1, 2) }

    it 'returns the correct x coordinate' do
      expect(obstacle.x).to eq(1)
    end

    it 'returns the correct y coordinate' do
      expect(obstacle.y).to eq(2)
    end
  end
end
