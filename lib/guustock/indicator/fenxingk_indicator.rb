require_relative 'indicator'
require_relative 'czsc_helper'

module Guustock
  class FenxingkIndicator < Indicator
    def initialize()
    end

    def name()
      "fenxingk"
    end

    def lookback()
      1
    end

    def calculate(bar_array)
      range = valid_range(bar_array)
      range.each do |i|
      size = forward_bar_list.size()
      #puts "calculate size : #{forward_bar_list.size()}"
      @macd.calculate(forward_bar_list)
      #generate standard bar first
      isize = forward_bar_list.isize[standard_name()]
      #previous_bar = []
      #previous_bar << forward_bar_list[isize-1] if isize>0
      last_cbar = nil
      last_cbar = CzscBarValue.new(forward_bar_list[isize-1]) if isize>0
      start = isize
      move = NO_MOVE
      start.upto(size-1) do |i|
        bar = forward_bar_list[i]
        #if previous_bar.empty?
          #previous_bar << bar
          #next
        #end
        if last_cbar.nil?
          last_cbar = CzscBarValue.new(bar)
          next
        end
        relation = CzscHelper.relation(last_cbar, bar)
        if relation == BAR_HIGHER
          move = MOVE_UP
        elsif relation == BAR_LOWER
          move = MOVE_DOWN
        else
          #raise "#{forward_bar_list}"
          #keep move not change
        end
        if CzscHelper.try_merge(last_cbar, bar, move)
          #do sth?
        else
          isize = i
          if move!=NO_MOVE
            forward_bar_list[i-1].indicator[standard_name()] = last_cbar
          end
          last_cbar = CzscBarValue.new(bar)
        end
      end
      forward_bar_list.isize[standard_name()] = isize


      isize = forward_bar_list.isize[name()]
      s_isize = forward_bar_list.isize[standard_name()]
      start = isize
      cbar_array = []
      index_array = []
      start.upto(size-2) do |i|
        cbar = forward_bar_list[i].indicator[standard_name()]
        unless cbar.nil?
          cbar_array << cbar
          index_array << i
        end
        next if char_array.size<3
        if CzscHelper.relation(cbar_array[0], cbar_array[1])==BAR_HIGHER and CzscHelper.relation(cbar_array[1], cbar_array[2])==BAR_LOWER
          forward_bar_list[index_array[0]].indicator[name()] = FX_DI_LEFT
          forward_bar_list[index_array[1]].indicator[name()] = FX_DI
          forward_bar_list[index_array[2]].indicator[name()] = FX_DI_RIGHT
          cbar_array.clear
          index_array.clear
          isize = i+1
        elsif CzscHelper.relation(cbar_array[0], cbar_array[1])==BAR_LOWER and CzscHelper.relation(cbar_array[1], cbar_array[2])==BAR_HIGHER
          forward_bar_list[index_array[0]].indicator[name()] = FX_DING_LEFT
          forward_bar_list[index_array[1]].indicator[name()] = FX_DING
          forward_bar_list[index_array[2]].indicator[name()] = FX_DING_RIGHT
          cbar_array.clear
          index_array.clear
          isize = i+1
        else
          forward_bar_list[index_array[0]].indicator[name()] = FX_OTHER
          cbar_array.delete_at(0)
          index_array.delete_at(0)
          isize = i-1
        end
      end
      forward_bar_list.isize[name()] = isize
    end

  end

end
      
