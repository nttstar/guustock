require 'date'
module Guustock

  class Bar
    attr_accessor :id, :time, :vol
    attr_accessor :period, :indicator
    def initialize(id = nil, time = nil, start = 0.0, high = 0.0, low = 0.0, close = 0.0, vol = 0.0)
      @id = id
      @time = time
      @start = start
      @high = high
      @low = low
      @close = close
      @vol = vol
      @period = 5
      @indicator = {}
    end

    def start

      @start.round(2)
    end

    def high

      @high.round(2)
    end
    def low

      @low.round(2)
    end
    def close

      @close.round(2)
    end
    def set_key(key)
      @id, stime = key.split('>')
      @time = Bar.parse_time_str(stime)
    end

    def set_value(value)
      obj_value = Marshal.load(value)
      @start = obj_value[0]
      @high = obj_value[1]
      @low = obj_value[2]
      @close = obj_value[3]
      @vol = obj_value[4]
    end

    def self.parse(key, value)
      bar = Bar.new
      bar.set_key(key)
      bar.set_value(value)
      return bar
    end
    
    def to_s
      time_s = @time.strftime("%FT%R")
      indicator_str = ""
      @indicator.each do |key, value|
        indicator_str += "[#{key}:#{value}]"
      end
      "#{@id},#{time_s},#{@start},#{@high},#{@low},#{@close},#{@vol},#{@period} ! #{indicator_str}"
    end
    
    def avg
      (@start+@close)/2.0
    end

    def price
      (@start+@close*2)/3.0
    end
    
    def self.key_time_str(time)
      time.strftime("%Y%m%d%H%M")
    end

    def self.parse_time_str(stime)
      dt = DateTime.strptime(stime, "%Y%m%d%H%M")
      return Time.mktime(dt.year, dt.month, dt.day, dt.hour, dt.min, 0, 0)
    end
    
    def self.get_key_impl(id, time)
      time_s = key_time_str(time)
      "#{id}>#{time_s}"
    end
    
    def get_key
      Bar.get_key_impl(@id, @time)
    end
    
    def get_value
      obj_value = [@start, @high, @low, @close, @vol]
      Marshal.dump(obj_value)
    end
    
  end

end

