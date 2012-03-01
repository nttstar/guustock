require_relative 'indicator'

module Guustock
  class LinearIndicator < Indicator
    def initialize(coef)
      @coef = coef
      #puts "lookback : #{lookback()}"
    end

    def name()
      "linear"
    end

    def lookback()
      @coef.size()-1
    end

    def calculate(bar_array)
      #puts "calculate size : #{forward_bar_list.size()}"
      range = valid_range(bar_array)
      return if range.nil?
      #puts "range : #{range}"
      range.each do |i|
        bar = bar_array[i]
        next if !bar.indicator[name()].nil?
        pos = i-lookback()
        result = 0.0
        (0...@coef.size()).each do |ic|
          #puts "status #{pos} - #{ic} - #{i}"
          result += bar_array[pos].price() * @coef[ic]
          pos += 1
        end
        bar.indicator[name()] = result
      end
    end

  end
end
      
