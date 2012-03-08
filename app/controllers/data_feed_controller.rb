require 'guustock/db/bar_db_reader'

class DataFeedController < ApplicationController
  include Guustock
  def bar
    @id = params['id']
    @year = params['year']
    @period = params['period']
    @period = 5 if @period.nil?
    periods = [@period]
    db_reader = BarDbReader.instance
    start_time = Time.mktime(@year)
    @bar_array = []
    db_reader.forward_each(id, start_time, periods) do |bars|
      #puts bars[0]
      bar = bars.first
      @bar_array << bar
    end
  end
end
