module BotBox
  module TableTops
    # An obstacle on the table top.
    #
    # @param x [Integer] - the x-coordinate of the obstacle.
    # @param y [Integer] - the y-coordinate of the obstacle.
    #
    # Example:
    class Obstacle
      # @attribute [Integer] x - the x-coordinate of the obstacle.
      # @attribute [Integer] y - the y-coordinate of the obstacle.
      attr_reader :x, :y

      def initialize(x, y)
        @x = x
        @y = y
      end
    end
  end
end