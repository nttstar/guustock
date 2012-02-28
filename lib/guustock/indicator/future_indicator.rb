require_relative 'indicator'

module Guustock
  class FutureIndicator < Indicator
    def initialize
    end

    def name()
      "future_indicator"
    end

    def lookback()
      0
    end

    def lookforward()
      0
    end

    def valid_range(forward_bar_list)
      start = forward_bar_list.isize[name()]
      vstart = [lookback(), start].max
      vend = forward_bar_list.size() - lookforward()
      return nil if vstart>=vend
      vstart..vend
    end


    def calculate(forward_bar_list)
    end

  end
end
      
