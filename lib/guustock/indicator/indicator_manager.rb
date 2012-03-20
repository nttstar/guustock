require_relative 'indicator.rb'
require_relative 'macd_indicator.rb'
require_relative 'fenxingk_indicator.rb'
require_relative 'fakefenxing_indicator.rb'
require_relative 'fenxing_indicator.rb'

module Guustock

  class IndicatorManager

    def add(indicator)
      @instance[indicator.name()] = indicator
    end

    def initialize
      @instance = {}
      i = MacdIndicator.new
      add(i)
      i = FenxingkIndicator.new
      add(i)
      i = FakefenxingIndicator.new
      add(i)
      i = FenxingIndicator.new
      add(i)
    end

    @@instance = IndicatorManager.new

    def self.instance
      
      @@instance
    end


    def get_indicator(name)
      
      @instance[name]
    end

    def calculate(indicator_name, bar_array)
      indicator = get_indicator(indicator_name)
      indicator.dependencies.each do |dname|
        calculate(dname, bar_array)
      end
      indicator.calculate(bar_array)
    end

  end

end
