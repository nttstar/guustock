
module Guustock
  class Indicator
    def initialize
    end

    def name()
      "indicator"
    end

    def lookback()
      0
    end

    def valid_range(forward_bar_list, start)
      #start = forward_bar_list.isize[name()]
      vstart = [lookback(), start].max
      vend = forward_bar_list.size()
      return nil if vstart>=vend
      vstart...vend
    end


    def calculate(forward_bar_list)
    end

  end
end
      
