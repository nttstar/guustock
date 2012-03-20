puts "!!!RELOADING"
require_relative 'indicator'
require_relative 'czsc_helper'
require_relative 'czsc_indicator_base'

module Guustock
  class FenxingIndicator < CzscIndicatorBase
    def initialize()
      depend_on("fenxingk")
    end

    def name()
      "fenxing"
    end

    def min_lookback()
      
      0
    end

    def max_lookback()

      0
    end

    def lookforward()

      0
    end

    ValueType ||= Struct.new(:cbar, :index, :fenxing)


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
          #do reverse search
          fenxing_distance = 0
          (fx_index-1).downto(0).each do |b|
            puts "b:#{b}"
            sk = bar_array[b].indicator[cname]
            fenxing_distance += 1 unless sk.nil?
            fx = bar_array[b].indicator[name()]
            next if fx.nil?
            next if fx!=FX_DI and fx!=FX_DING
            if fx==fx_candidate #duplicate
              bar_array[b].indicator[name()] = nil
              #puts "dup at #{b}"
            else 
              if fenxing_distance <= 3
                fx_candidate = FX_OTHER
              end
            end
            break
          end
        end
        if fx_candidate==FX_DI or fx_candidate==FX_DING
          bar_array[fx_index].indicator[name()] = fx_candidate
          isize = fx_index+1
          value_array.clear
          #puts "find FX at #{fx_index}"
        else
          isize = value_array[0].index+1
          value_array.delete_at(0)
        end
      end
      bar_array.isize[name()] = isize

      #do post filter
      #fenxing_list = []
      #type = FX_OTHER
      #range.each do |i|
        #fenxing = bar_array[i].indicator[name()]
        #next if fenxing.nil?
        #if fenxing!=type and !fenxing_list.empty?
          
        #end
      #end

    end

  end

end
      
