require_relative 'indicator_manager.rb'

module Guustock

  class IndicatorCalculator
    def self.calculate(name, bar_array)
      IndicatorManager.instance.calculate(name, bar_array)
    end
  end

end
