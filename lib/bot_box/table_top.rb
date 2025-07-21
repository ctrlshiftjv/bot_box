# frozen_string_literal: true

require "bot_box/table_tops/obstacle"

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

    # @param length [Integer] - the length of the table top (x-axis).
    # @param width [Integer] - the width of the table top (y-axis).
    attr_reader :length, :width

    # @attribute [Array<Obstacle>] - the obstacles on the table top.
    attr_reader :obstacles

    def initialize(length:, width:, obstacles: nil)
      BotBox.logger.info "Initializing table top with length: #{length} and width: #{width}"

      if length.nil? || width.nil? || length <= 0 || width <= 0
        raise ArgumentError, "Length and width must greater than zero."
      end

      @length = length
      @width = width

      @obstacles = obstacles || []

      BotBox.logger.info "Table top initialized with length: #{length} and width: #{width}"
    end

    # Check if the table top has an obstacle at the given coordinates.
    #
    # @param x [Integer] - the x-coordinate of the position.
    # @param y [Integer] - the y-coordinate of the position.
    #
    # @return [Boolean] - true if the table top has an obstacle at the given coordinates, false otherwise.
    def has_obstacles?(x,y)
      obstacles.any? { |obstacle| obstacle.x == x && obstacle.y == y }
    end

  end
end