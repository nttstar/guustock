require_relative '../db/bar_db_reader.rb'
require_relative 'indicator_runner.rb'

module Guustock
  class IndicatorViewer

    attr_reader :bar_sequence

    def initialize(indicator_name)
      @indicator_name = indicator_name
      @bar_sequence = []
    end

    def view(id, periods = [5,30], start_time = Time.at(0), end_time = Time.mktime(3000))
      indicator = IndicatorManager.instance.get_indicator(@indicator_name)
      back = indicator.max_lookback() #treat back as days
      forward = indicator.lookforward()
      run_start_time = start_time - back*24*3600
      run_end_time = end_time + forward*24*3600
      runner = IndicatorRunner.new(@indicator_name, true)
      db_reader = BarDbReader.instance
      db_reader.forward_each(id, run_start_time, periods) do |bars|
        #puts bars[0]
        break if bars.first.time>=run_end_time
        bars.each do |bar|
          runner.add(bar)
        end   
        if bars.first.time>=start_time and bars.first.time<end_time
          @bar_sequence << bars
          #bars.each do |bar|
            #puts "V : #{bar}"
          #end
        end
      end

      @bar_sequence.each do |bars|
        bars.each do |bar|
          puts "E : #{bar}"
        end
      end

    end
  end

end

