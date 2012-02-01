require_relative '../db/bar_db_reader.rb'

module Guustock
  class IndicatorRunner

    def initialize(indicator, single_id = false)
      @indicator = indicator
      @single_id = single_id
      @indicator_name = indicator.name()
      @lookback = @indicator.lookback()
      @db_reader = BarDbReader.instance
      @forward_bars = {} 
      @compact_ratio = 5
      @max_in_buffer = @lookback*@compact_ratio
    end

    def add(bar)
      if @single_id
        key = bar.period
      else
        key = [bar.id, bar.period]
      end
      forward_bar = []
      if !@forward_bars.has_key?(key)
        @forward_bars[key] = forward_bar 
      else
        forward_bar = @forward_bars[key]
      end
      #puts "forward size : #{forward_bar.size()}"
      forward_bar << bar
      @indicator.calculate(forward_bar, -1)
      if forward_bar.size == @max_in_buffer
        forward_bar = forward_bar.last(@lookback)
        @forward_bars[key] = forward_bar
      end
    end
  end
end


