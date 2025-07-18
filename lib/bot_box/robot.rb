module BotBox
  class Robot

    attr_reader :x, :y, :f

    def initialize(x,y,f)
      @x = x
      @y = y
      @f = f
    end

  end
end