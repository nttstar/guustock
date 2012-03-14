require_relative '../common/bar.rb'

module Guustock

  BAR_CONTAINS = "CONTAINS"
  BAR_BE_CONTAINED = "BE_CONTAINED"
  BAR_HIGHER = "HIGHER"
  BAR_LOWER = "LOWER"
  BAR_EQUAL = "EQUAL"

  #MOVE_UP = 1
  #MOVE_DOWN = 2
  #NO_MOVE = 3

  DIRECTION_NO = "NO"
  DIRECTION_UP = "UP"
  DIRECTION_DOWN = "DOWN"

  FX_DI = "DI"
  FX_DI_LEFT = "DI_LEFT"
  FX_DI_RIGHT = "DI_RIGHT"
  FX_DING = "DING"
  FX_DING_LEFT = "DING_LEFT"
  FX_DING_RIGHT = "DING_RIGHT"
  FX_OTHER = "OTHER"

  CZSC_LOOKBACK = 50

  class CzscBarValue

    attr_accessor :start, :high, :low, :close, :direction
    def initialize(bar = nil, direction = DIRECTION_NO)
      unless bar.nil?
        @start = bar.start
        @high = bar.high
        @low = bar.low
        @close = bar.close
      else
        @start = 0.0
        @high = 0.0
        @low = 0.0
        @close = 0.0
      end
      @direction = direction
    end

    def to_s

      "start:#{@start},high:#{@high},low:#{@low},close:#{@close},direction:#{@direction}"
    end

  end

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

    def self.try_merge(cbar, bar)
      if cbar.direction==DIRECTION_NO
        return false
      else
        relat = relation(cbar, bar)
        if relat != BAR_CONTAINS and relat != BAR_BE_CONTAINED
          return false
        end
        if cbar.direction==DIRECTION_UP
          cbar.low = [cbar.low, bar.low].max
          cbar.high = [cbar.high, bar.high].max
        else
          cbar.low = [cbar.low, bar.low].min
          cbar.high = [cbar.high, bar.high].min
        end
        cbar.close = bar.close
        return true
      end

    end
  end


end

