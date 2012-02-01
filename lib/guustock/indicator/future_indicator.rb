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

    def valid_range(forward_bar_list, start = 0)
      if start<0
        start = forward_bar_list.size()+start
      end
      return nil if start<0
      vstart = [lookback(), start].max
      vend = forward_bar_list.size() - lookforward()
      return nil if vstart>=vend
      vstart..vend
    end


    def calculate(forward_bar_list, start = 0)
    end

  end
end
      
