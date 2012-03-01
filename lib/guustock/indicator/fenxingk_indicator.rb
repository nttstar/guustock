require_relative 'indicator'
require_relative 'czsc_helper'
require_relative 'czsc_indicator_base'

module Guustock
  class FenxingkIndicator < CzscIndicatorBase
    def initialize()
    end

    def name()
      "fenxingk"
    end

    def min_lookback()
      1
    end

    def lookforward()

      1
    end

    def calculate(bar_array)
      range = valid_range(bar_array)
      return if range.nil?
      size = bar_array.size()
      isize = bar_array.isize[name()]
      #generate standard bar first
      last_cbar = nil
      (range.begin-1).downto(0) do |i|
        cbar = bar_array[i].indicator[name()]
        unless cbar.nil?
          last_cbar = cbar
          break
        end
      end

      if last_cbar.nil?
        last_cbar = CzscBarValue.new(bar_array[range.begin-1])
      end
      range.each do |i|
        bar = bar_array[i]
        #if last_cbar.nil?
          #last_cbar = CzscBarValue.new(bar)
          #next
        #end
        relation = CzscHelper.relation(last_cbar, bar)
        direction = DIRECTION_NO
        if relation == BAR_HIGHER
          direction = DIRECTION_DOWN
        elsif relation == BAR_LOWER
          direction = DIRECTION_UP
        else
          #raise "#{bar_array}"
          #keep direction not change
        end

        #puts "cbar #{last_cbar}"
        #puts "bar #{bar}"
        #puts "relation #{relation}"
        #puts "direction #{direction}"
        
        if CzscHelper.try_merge(last_cbar, bar)
          #do sth?
        else
          isize = i
          if last_cbar.direction!=DIRECTION_NO
            bar_array[i-1].indicator[name()] = last_cbar
          end
          last_cbar = CzscBarValue.new(bar, direction)
        end
      end
      bar_array.isize[name()] = isize


    end

  end

end
      
