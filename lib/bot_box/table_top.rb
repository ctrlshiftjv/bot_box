
module BotBox
  # A table top on which the robot can move.
  # 
  # The table top is a rectangle, with a length and a width.
  #
  # @param length [Integer] - the length of the table top.
  # @param width [Integer] - the width of the table top.
  #
  # Example:
  # table_top = TableTop.new(length: 5, width: 5)
  class TableTop

    # length - the length of the table top.
    # width - the width of the table top.
    attr_reader :length, :width

    def initialize(length:, width:)
      BotBox.logger.info "Initializing table top with length: #{length} and width: #{width}"

      @length = length
      @width = width

      BotBox.logger.info "Table top initialized with length: #{length} and width: #{width}"
    end

  end
end