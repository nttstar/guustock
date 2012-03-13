require 'guustock/db/bar_db_reader'

class DataFeedController < ApplicationController
  respond_to :json
  include Guustock
  def bar
    @id = params['id']
    @year = params['year'].to_i
    @period = params['period']
    @period = "5" if @period.nil?
    @period = @period.to_i
    periods = [@period]
    db_reader = BarDbReader.instance
    start_time = Time.mktime(@year)
    end_time = Time.mktime(@year+1)
    @bar_array = []
    @data_array = []
    db_reader.forward_each(@id, start_time, periods) do |bars|
      #puts bars[0]
      #puts bars.size
      bar = bars[0]
      break if bar.time>=end_time
      @bar_array << bar
      #data = [bar.time.to_i*1000, bar.start, bar.high, bar.low, bar.close, bar.vol, bar.period]
      data = [(bar.time.to_i+8*3600)*1000, bar.start, bar.high, bar.low, bar.close]
      @data_array << data
    end
    #render :bar, :layout => false
    render :json => @data_array
  end
end
