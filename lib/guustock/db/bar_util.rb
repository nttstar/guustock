require_relative '../common/bar.rb'

module Guustock
  class BarUtil
    def initialize()
    end

    def self.check_time(bar)
      minute = bar.time.min
      if minute % bar.period==0
        true
      else
        false
      end
    end

    def self.sum(bar_buffer)
      sorted = bar_buffer.sort { |x, y| x.time<=>y.time }

      id = sorted[0].id
      endtime = sorted[-1].time
      start = sorted[0].start
      high = sorted.max { |a, b| a.high<=>b.high }.high
      low = sorted.min { |a, b| a.low<=>b.low }.low
      close = sorted[-1].close
      vol = sorted.inject(0.0) { |sum, bar| sum += bar.vol}
      first_endtime = sorted[0].time
      iendtime = endtime.to_i
      ifendtime = first_endtime.to_i
      period = (iendtime-ifendtime)/60+sorted[0].period #period is minutes
      bar = Bar.new(id, endtime, start, high, low, close, vol)
      bar.period = period
      return bar
    end
      
  end
end


