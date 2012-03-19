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
      1
    end

    def lookforward()

      10
    end

    ValueType = Struct.new(:cbar, :index)

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
        end
        next if value_array.size<3
        relation01 = CzscHelper.relation(value_array[0].cbar, value_array[1].cbar) 
        relation12 = CzscHelper.relation(value_array[1].cbar, value_array[2].cbar) 
        fx_candidate = FX_OTHER
        if relation01==BAR_HIGHER and relation12==BAR_LOWER
          fx_candidate = FX_DI
        elsif relation01==BAR_LOWER and relation12==BAR_HIGHER
          fx_candidate = FX_DING
        end
        fx_index = value_array[1].index
        if fx_candidate==FX_DI or fx_candidate==FX_DING
          #do reverse search
          fenxing_distance = 0
          (fx_index-1).downto(0).each do |b|
            #puts "b:#{b}"
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
        else
          isize = value_array[0].index+1
          value_array.delete_at(0)
        end
      end
      bar_array.isize[name()] = isize
    end

  end

end
      
