require_relative '../db/bar_db_reader.rb'
require_relative 'indicator_runner.rb'

module Guustock
  class IndicatorViewer
    def initialize(indicator, match_all = false)
      @indicator = indicator
      @match_all = match_all
    end

    def view(id, time = Time.at(0), periods = [5,15])
      runner = IndicatorRunner.new(@indicator, false)
      indicator_name = @indicator.name()
      db_reader = BarDbReader.instance
      db_reader.forward_each(id, time, periods) do |bars|
        is_match_all = (bars.size == periods.size)
        bars.each do |bar|
          runner.add(bar)
          is_match_all = false if bar.indicator[@indicator.name()].nil?
        end   
        if is_match_all or !@match_all
          bars.each do |bar|
            puts "V : #{bar}"
          end
        end
      end
    end
  end

end

