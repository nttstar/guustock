require 'guustock/view/google_chart_viewer'
#require 'lazy_high_charts'


class ChartsController < ApplicationController
  layout "chart"

  def show
    @indicator_name = params['indicator']
    @id = params['id']
    @start = Date.strptime(params['start'], "%Y%m%d").to_time
    @end = Date.strptime(params['end'], "%Y%m%d").to_time
  end

  def bar
    @indicator_name = "NONE"
    @id = params['id']
    @year = params['year'].to_i
    #@h = LazyHighCharts::HighChart.new('graph') do |f|
      #f.option[:title][:text] = "Test stock"
      #f.option[:chart][:renderTo] = "container"
      #f.series(:type => "candlestick", :name => "A", :data => [[1110240000000,41.90,42.16,40.10,40.53],[1110326400000,39.44,40.28,38.83,39.35]])
    #end
    
    respond_to do |format|
      format.html do
        render :action => "common"
      end
      format.js do
        @ohlc_data_source = url_for(:action => "bar", :controller => "data_feed")
        @ohlc_data_source = "#{@ohlc_data_source}?id=#{@id}&year=#{@year}"
        #puts "url : #{@ohlc_data_source}"
        render :action => "bar"
      end
    end
  end

  def fenxing
    @indicator_name = "fenxing"
    @id = params['id']
    @year = params['year'].to_i
    #@h = LazyHighCharts::HighChart.new('graph') do |f|
      #f.option[:title][:text] = "Test stock"
      #f.option[:chart][:renderTo] = "container"
      #f.series(:type => "candlestick", :name => "A", :data => [[1110240000000,41.90,42.16,40.10,40.53],[1110326400000,39.44,40.28,38.83,39.35]])
    #end
    
    respond_to do |format|
      format.html do
        render :action => "common"
      end
      format.js do
        @ohlc_data_source = url_for(:action => "fenxing", :controller => "data_feed")
        @ohlc_data_source = "#{@ohlc_data_source}?id=#{@id}&year=#{@year}"
        render :action => "fenxing"
      end
    end
  end

end
