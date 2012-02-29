
module Guustock
  class Indicator

    #attr_reader :dependencies

    def initialize
      #@dependencies = []
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

    def lookback()
      0
    end

    def barback()
      
      lookback()
    end

    def valid_range(bar_array)
      start = bar_array.isize[name()]
      vstart = [lookback(), start].max
      vend = bar_array.size()
      return Range.new(0,0,true) if vstart>=vend

      vstart...vend
    end


    def calculate(bar_array)
    end

  end
end
      
