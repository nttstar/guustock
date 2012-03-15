require_relative '../db/bar_db_reader.rb'
require_relative '../common/bar_array.rb'
require_relative 'indicator_calculator.rb'

module Guustock
  class IndicatorRunner

    def initialize(indicator_name, single_id = false)
      @indicator_name = indicator_name
      @single_id = single_id
      @db_reader = BarDbReader.instance
      @forward_bars = {} 
      @compact_ratio = 5
      #@lookback = @indicator.lookback()
      #@max_in_buffer = @lookback*@compact_ratio
    end

    def add(bar)
      if @single_id
        key = bar.period
      else
        key = [bar.id, bar.period]
      end
      forward_bar = BarArray.new
      if !@forward_bars.has_key?(key)
        @forward_bars[key] = forward_bar 
      else
        forward_bar = @forward_bars[key]
      end
      #puts "forward size : #{forward_bar.size()}"
      forward_bar << bar
      #IndicatorCalculator.calculate(@indicator_name, forward_bar)
      #if forward_bar.size == @max_in_buffer
        #forward_bar = forward_bar.last(@lookback)
        #@forward_bars[key] = forward_bar
      #end
    end

    def calculate()
      @forward_bars.each do |key, forward_bar|
        IndicatorCalculator.calculate(@indicator_name, forward_bar)
      end
    end

    def get_bar_array(id, period)
      if @single_id
        key = period
      else
        key = [id, period]
      end
      
      @forward_bars[key]
    end

  end
end


