puts "!!!RELOADING"
require_relative 'indicator'
require_relative 'czsc_helper'
require_relative 'czsc_indicator_base'

module Guustock
  class FenxingIndicator < CzscIndicatorBase
    def initialize()
      depend_on("fakefenxing")
    end

    def name()
      "fenxing"
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

    ValueType ||= Struct.new(:index, :cindex, :fenxing)


    def calculate(bar_array)
      range = valid_range(bar_array)
      return if range.nil?

      cname = "fenxingk"
      fname = "fakefenxing"
      value_array = []
      size = bar_array.size()
      isize = bar_array.isize[name()]

      cindex = 0
      pre_fx_value = nil
      range.each do |i|
        fakefx = bar_array[i].indicator[fname]
        cindex+=1 unless bar_array[i].indicator[cname].nil?
        unless fakefx.nil?
          value_array << ValueType.new(i, cindex, fakefx)
          #puts "cbar:#{cbar}"
        end
        next if value_array.empty?
        to_pick_fx = (i==range.end)
        unless to_pick_fx
          pre_cindex = nil
          value_array.each do |v|
            unless pre_cindex.nil?
              if v.cindex-pre_cindex>=3
                to_pick_fx = true
                break
              end
            end
            pre_cindex = v.cindex
          end
        end
        next unless to_pick_fx
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
      
