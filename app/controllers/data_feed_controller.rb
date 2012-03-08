require 'guustock/db/bar_db_reader'

class DataFeedController < ApplicationController
  include Guustock
  def bar
    @id = params['id']
    @year = params['year'].to_i
    @period = params['period'].to_i
    @period = 5 if @period.nil?
    periods = [@period]
    db_reader = BarDbReader.instance
    start_time = Time.mktime(@year)
    end_time = Time.mktime(@year+1)
    @bar_array = []
    db_reader.forward_each(@id, start_time, periods) do |bars|
      #puts bars[0]
      #puts bars.size
      bar = bars[0]
      break if bar.time>=end_time
      @bar_array << bar
    end
  end
end
