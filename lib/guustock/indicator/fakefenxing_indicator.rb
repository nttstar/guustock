puts "!!!RELOADING"
require_relative 'indicator'
require_relative 'czsc_helper'
require_relative 'czsc_indicator_base'

module Guustock
  class FakefenxingIndicator < CzscIndicatorBase
    def initialize()
      depend_on("fenxingk")
    end

    def name()
      "fakefenxing"
    end

    #def min_lookback()
      
      #0
    #end

    #def max_lookback()

      #0
    #end

    #def lookforward()

      #0
    #end

    ValueType ||= Struct.new(:cbar, :index)


    def calculate(bar_array)
      range = valid_range(bar_array)
      return if range.nil?

      cname = "fenxingk"
      value_array = []
      size = bar_array.size()
      isize = bar_array.isize[name()]

      cisize = bar_array.isize[cname]
      range.each do |i|
        cbar = bar_array[i].indicator[cname]
        unless cbar.nil?
          value_array << ValueType.new(cbar, i)
          #puts "cbar:#{cbar}"
        end
        next if value_array.size<3
        direction1 = value_array[1].cbar.direction
        direction2 = value_array[2].cbar.direction
        fx_candidate = FX_OTHER
        if direction1==DIRECTION_DOWN and direction2==DIRECTION_UP
          fx_candidate = FX_DI
        elsif direction2==DIRECTION_DOWN and direction1==DIRECTION_UP
          fx_candidate = FX_DING
        end
        fx_index = value_array[1].index
        if fx_candidate==FX_DI or fx_candidate==FX_DING
          bar_array[fx_index].indicator[name()] = fx_candidate
          isize = fx_index+1
          #puts "find FX at #{fx_index}"
        else
          isize = value_array[0].index+1
        end
        value_array.delete_at(0)
      end
      bar_array.isize[name()] = isize

    end

  end

end
      
