require_relative 'indicator'
require_relative 'czsc_helper'

module Guustock
  class CzscIndicatorBase < Indicator

    def min_lookback()

      1
    end

    def max_lookback()

      CZSC_LOOKBACK
    end

    

  end

end

