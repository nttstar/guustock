require_relative 'indicator'

module Guustock
  class FenxingIndicator < Indicator
    def initialize()
    end

    def name()
      "fenxing"
    end

    def lookback()
      120
    end

    def calculate(forward_bar_list, start = 0)
      #puts "calculate size : #{forward_bar_list.size()}"
      if start<0
        start = forward_bar_list.size()+start
      end
      return if start<0
      @macd.calculate(forward_bar_list, start)
      start.upto(forward_bar_list.size()-1) do |i|
        bar = forward_bar_list[i]
        next if i<lookback()
        next if !bar.indicator[name()].nil?
        result = nil
        #TODO
        bar.indicator[name()] = result
      end
    end

  end

end
      
