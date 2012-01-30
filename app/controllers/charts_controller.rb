class ChartsController < ApplicationController
  def show
    @id = params['id']
    @start = Date.strptime(params['start'], "%Y%m%d").to_time
    @end = Date.strptime(params['end'], "%Y%m%d").to_time
    @indicator = params['indicator']
  end
end
