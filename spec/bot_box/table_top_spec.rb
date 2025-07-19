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
end
