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
      #(range.begin-1).downto(0) do |i|
        #cbar = bar_array[i].indicator[cname]
        #unless cbar.nil?
          #value_array << ValueType.new(cbar, i)
          #break
        #end
      #end

      cisize = bar_array.isize[cname]
      range.each do |i|
        cbar = bar_array[i].indicator[cname]
        unless cbar.nil?
          value_array << ValueType.new(cbar, i)
        end
        next if value_array.size<3
        relation01 = CzscHelper.relation(value_array[0].cbar, value_array[1].cbar) 
        relation12 = CzscHelper.relation(value_array[1].cbar, value_array[2].cbar) 
        if relation01==BAR_HIGHER and relation12==BAR_LOWER
          fx_index = value_array[1].index
          #bar_array[value_array[0].index].indicator[name()] = FX_DI_LEFT
          bar_array[fx_index].indicator[name()] = FX_DI
          #bar_array[value_array[2].index].indicator[name()] = FX_DI_RIGHT
          isize = value_array[2].index+1
          value_array.clear

          i = fx_index-1
          while i>=0
            fx = bar_array[i].indicator[name()]
            if !fx.nil? and (fx==FX_DI or fx==FX_DING)
              if fx==FX_DI #duplicate
                bar_array[i].indicator[name()] = nil
              end
              break
            end
            i-=1
          end

        elsif relation01==BAR_LOWER and relation12==BAR_HIGHER
          fx_index = value_array[1].index
          #bar_array[value_array[0].index].indicator[name()] = FX_DING_LEFT
          bar_array[fx_index].indicator[name()] = FX_DING
          #bar_array[value_array[2].index].indicator[name()] = FX_DING_RIGHT
          isize = value_array[2].index+1
          value_array.clear

          i = fx_index-1
          while i>=0
            fx = bar_array[i].indicator[name()]
            if !fx.nil? and (fx==FX_DI or fx==FX_DING)
              if fx==FX_DING #duplicate
                bar_array[i].indicator[name()] = nil
              end
              break
            end
            i-=1
          end

        else
          #bar_array[value_array[0].index].indicator[name()] = FX_OTHER
          isize = value_array[0].index+1
          value_array.delete_at(0)
        end
      end
      bar_array.isize[name()] = isize
    end

  end

end
      
