require_relative "../common/bar.rb"
require_relative "bar_db.rb"
require_relative "bar_util.rb"

module Guustock
  
  class BarDbReader
    def initialize(db)
      @db = db
    end

    @@instance = BarDbReader.new(BarDb.instance)

    def self.instance
        return @@instance
    end
    
    def forward_each(id, time, periods = [5,30])
      max_period = periods.max
      raw_period = BarDb.raw_period
      buffer_match_size = periods.collect { |p| p/raw_period }
      max_buffer_size = max_period/raw_period
      buffer = []
      @db.forward_each(id, time) do |raw_bar|
        output = []
        buffer << raw_bar 
        buffer_size = buffer.size()
        buffer_match_size.each_with_index do |m, i|
          break if m>buffer_size
          match_buffer = buffer[buffer_size-m, m]
          bar = BarUtil::sum(match_buffer)
          next if bar.period!=periods[i]
          next if !BarUtil::check_time(bar)
          output << bar
        end
        yield output unless output.empty?
        buffer.clear() if buffer_size==max_buffer_size 
      end

    end
    
    
  end
end


