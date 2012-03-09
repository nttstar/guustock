require 'guustock/view/google_chart_viewer'


class ChartsController < ApplicationController
  #layout "chart"

  def initialize
    @chart = Guustock::GoogleChartViewer.new
  end

  def show
    @indicator_name = params['indicator']
    @id = params['id']
    @start = Date.strptime(params['start'], "%Y%m%d").to_time
    @end = Date.strptime(params['end'], "%Y%m%d").to_time
    @succ, @msg, @chart_url = @chart.to_url(@indicator_name, @id, @start, @end)
    #@chart_url = "http://chart.apis.google.com/chart?chxt=y&cht=lc&chd=s:UhG9AN,NbAo9U&chs=400x200&chxr=0,0,10&chco=00ff00,ff0000&chtt=My+Results&chxs=0,10,0&chm=o,0000ff,0,-1,10"
  end
end
