require_relative '../common/bar.rb'

module Guustock

  BAR_CONTAINS = 1
  BAR_BE_CONTAINED = 2
  BAR_HIGHER = 3
  BAR_LOWER = 4
  BAR_EQUAL = 5

  MOVE_UP = 1
  MOVE_DOWN = 2
  NO_MOVE = 3

  FX_DI = 1
  FX_DI_LEFT = 2
  FX_DI_RIGHT = 3
  FX_DING = 4
  FX_DING_LEFT = 5
  FX_DING_RIGHT = 6
  FX_OTHER = 7

  class CzscHelper
    def self.relation(from, to)
      if from.high>to.high
        if from.low<=to.low
          return BAR_CONTAINS
        else
          return BAR_HIGHER
        end
      elsif from.high==to.high
        if from.low<to.low
          return BAR_CONTAINS
        elsif from.low==to.low
          return BAR_EQUAL
        else 
          return BAR_BE_CONTAINED
        end
      else
        if from.low<to.low
          return BAR_LOWER
        else
          return BAR_BE_CONTAINED
        end
      end
    end

    def self.try_merge(bar, param, move)
      if move==NO_MOVE
        return false
      else
        relat = relation(bar, param)
        if relat != BAR_CONTAINS and relat != BAR_BE_CONTAINED
          return false
        end
        if move==MOVE_UP
          bar.low = [bar.low, param.low].max
          bar.high = [bar.high, param.high].max
        else
          bar.low = [bar.low, param.low].min
          bar.high = [bar.high, param.high].min
        end
        return true
      end

    end
  end

  class CzscBarValue

    attr_reader :high, :low
    def initialize(bar)
      @high = bar.high
      @low = bar.low
    end

  end

end

