require 'guustock/db/bar_db_reader'
require 'guustock/indicator/indicator_viewer'

class DataFeedController < ApplicationController
  respond_to :json
  include Guustock
  def bar
    @id = params['id']
    @year = params['year'].to_i
    @month = nil
    @day = nil
    @month = params['month'].to_i unless params['month'].nil?
    @day = params['day'].to_i unless params['day'].nil?
    @period = params['period']
    @period = "5" if @period.nil?
    @period = @period.to_i
    periods = [@period]
    db_reader = BarDbReader.instance
    start_time = Time.mktime(@year)
    if !@day.nil?
      end_time = Time.mktime(@year, @month, @day+1)
    elsif !@month.nil?
      end_time = Time.mktime(@year, @month+1, @day)
    elsif !@year.nil?
      end_time = Time.mktime(@year+1, @month, @day)
    end
    @bar_array = []
    @data_array = []
    db_reader.forward_each(@id, start_time, periods) do |bars|
      #puts bars[0]
      #puts bars.size
      bar = bars[0]
      break if bar.time>=end_time
      @bar_array << bar
      #data = [bar.time.to_i*1000, bar.start, bar.high, bar.low, bar.close, bar.vol, bar.period]
      data = [(bar.time.to_i+8*3600)*1000, bar.open, bar.high, bar.low, bar.close, bar.vol]
      @data_array << data
    end
    #render :bar, :layout => false
    render :json => @data_array
  end

  def fenxing
    @id = params['id']
    @year = nil
    @month = nil
    @day = nil
    @year = params['year'].to_i unless params['year'].nil?
    @month = params['month'].to_i unless params['month'].nil?
    @day = params['day'].to_i unless params['day'].nil?
    start_time, end_time = get_time_range(@year, @month, @day)
    return if start_time.nil? or end_time.nil?
    @period = params['period']
    @period = "5" if @period.nil?
    @period = @period.to_i
    periods = [@period]
    db_reader = BarDbReader.instance
    #start_time = Time.mktime(@year, @month, @day)
    #if !@day.nil?
      #end_time = Time.mktime(@year, @month, @day+1)
    #elsif !@month.nil?
      #end_time = Time.mktime(@year, @month+1, @day)
    #elsif !@year.nil?
      #end_time = Time.mktime(@year+1, @month, @day)
    #end
      
    viewer = IndicatorViewer.new("fenxing")
    viewer.view(@id, periods, start_time, end_time)
    @data_array = []
    viewer.bar_sequence.each do |bars|
      #puts bars[0]
      #puts bars.size
      bar = bars[0]
      #puts "vol:#{bar.vol}"
      data = [(bar.time.to_i+8*3600)*1000, bar.open, bar.high, bar.low, bar.close, bar.vol]
      fenxingk = bar.indicator['fenxingk']
      fenxing = bar.indicator['fenxing']
      #puts "fenxing:#{fenxing}"
      unless fenxingk.nil?
        data.concat([fenxingk.open, fenxingk.high, fenxingk.low, fenxingk.close])
        unless fenxing.nil?
          if fenxing==FX_DI
            data << 1
          elsif fenxing==FX_DING
            data << 2
          end
        end
      end
      @data_array << data
    end
    #render :bar, :layout => false
    render :json => @data_array
  end

  private
  def get_time_range(year, month, day)
    return nil,nil if year.nil?
    if month.nil? and day.nil?
      start_time = Time.mktime(year)
      end_time = Time.mktime(year+1)
    elsif !month.nil? and day.nil?
      start_time = Time.mktime(year, month)
      if(month<12)
        end_time = Time.mktime(year, month+1)
      else
        end_time = Time.mktime(year+1)
      end
    elsif !month.nil? and !day.nil?
      start_time = Time.mktime(year, month, day)
      end_time = start_time + (3600*24)
    else
      return nil, nil
    end

    puts "SE #{start_time}, #{end_time}"
    return start_time, end_time
  end

end
