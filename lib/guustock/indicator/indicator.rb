
module Guustock
  class Indicator


    def initialize
    end

    def dependencies
      @dependencies ||= Array.new

      @dependencies
    end

    def depend_on(name)
      dependencies << name
    end

    def name()
      "indicator"
    end

    #not be used, just for defining min_lookback and max_lookback
    def lookback()
      0
    end

    def min_lookback()

      lookback()
    end

    def max_lookback()

      min_lookback()
    end

    def lookforward()

      0
    end

    def valid_range(bar_array)
      start = bar_array.isize[name()]
      vstart = [min_lookback(), start].max
      vend = bar_array.size()
      #return Range.new(0,0,true) if vstart>=vend
      return nil if vstart>=vend

      vstart...vend
    end


    def calculate(bar_array)
    end

  end
end
      
