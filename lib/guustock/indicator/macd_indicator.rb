require_relative 'linear_util'
require_relative 'linear_indicator'

module Guustock
  class MacdIndicator < LinearIndicator
    def initialize(fast = 12, slow = 26, signal = 9)
      @fast = fast
      @slow = slow
      @signal = signal
      @coef = LinearUtil::macd_coef(@fast, @slow, @signal)

      super(@coef)
    end

    def name()
      #"macd,#{@fast},#{@slow},#{@signal}"
      "macd"
    end

  end
end

