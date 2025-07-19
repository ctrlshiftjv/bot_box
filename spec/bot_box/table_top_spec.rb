require 'spec_helper'

require 'bot_box/table_top'

RSpec.describe BotBox::TableTop do
  let(:table) { described_class.new(length: 5, width: 5) }

  describe '#initialize' do
    it 'sets length and width' do
      table = described_class.new(length: 5, width: 3)

      expect(table.length).to eq(5)
      expect(table.width).to eq(3)
    end
  end
end
