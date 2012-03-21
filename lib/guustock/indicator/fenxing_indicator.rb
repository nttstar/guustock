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

    ValueType ||= Struct.new(:cbar, :index, :cindex, :fenxing)


    def calculate(bar_array)
      range = valid_range(bar_array)
      return if range.nil?

      cname = "fenxingk"
      fname = "fakefenxing"
      value_array = []
      size = bar_array.size()
      isize = bar_array.isize[name()]

      cindex = 0
      left_value = nil
      range.each do |i|
        fakefx = bar_array[i].indicator[fname]
        cbar = bar_array[i].indicator[cname]
        cindex+=1 unless cbar.nil?
        unless fakefx.nil?
          value_array << ValueType.new(cbar, i, cindex, fakefx)
          #puts "cbar:#{cbar}"
        end
        next if value_array.empty?
        right_fake_value = nil
        to_pick_range = (i==range.end)?Range.new(0, value_array.size-1):nil
        if to_pick_range.nil?
          pre_cindex = nil
          value_array.each_with_index do |v, vi|
            unless pre_cindex.nil?
              if v.cindex-pre_cindex>3
                to_pick_range = Range.new(0, vi-1)
                right_fake_value = v
                break
              end
            end
            pre_cindex = v.cindex
          end
        end
        next if to_pick_range.nil?
        pre_value = nil
        later_value = nil
        search_space = []
        if !left_value.nil? or !right_fake_value.nil?
          if right_fake_value.nil?
            pre_value = left_value
            later_value = right_fake_value
            search_space = to_pick_range.to_a
          else
            pre_value = right_fake_value
            later_value = left_value
            search_space = to_pick_range.to_a.reverse!
          end
        end
        search_value = []
        search_space.each do |vi|
          search_value << value_array[vi]
        end

        valid_value = []

        #search_value.each do |value|
          #valid = true
          #unless pre_value.nil?
            #valid = false if value.fenxing==pre_value.fenxing
            #valid = false if (value.cindex-pre_value.cindex).abs<4
          #end
          #if valid
            #valid_value << value
            #pre_value = value
          #end
        #end
        #if !valid_value.empty? and !later_value.nil?
          #if valid_value.last.fenxing==later_value.fenxing
            #valid_value.clear
          #end
        #end

        #puts "search value size: #{search_value.size}"

        if search_value.size%2==1
          obj_fx = FX_DI
          if !pre_value.nil?
            if pre_value.fenxing==FX_DI
              obj_fx = FX_DING
            end
          else
            if later_value.fenxing==FX_DI
              obj_fx = FX_DING
            end
          end
          the_one = nil
          if obj_fx==FX_DI
            the_one = search_value.inject(search_value.first) {|t, v| v.cbar.close < t.cbar.close ? v : t}
          else
            the_one = search_value.inject(search_value.first) {|t, v| v.cbar.close > t.cbar.close ? v : t}
          end
          #puts "the_one:#{the_one}"
          valid_value << the_one
        end

        max_index_value = nil
        valid_value.each do |vv|
          bar_array[vv.index].indicator[name] = vv.fenxing
          if max_index_value.nil?
            max_index_value = vv
          elsif vv.index>max_index_value.index
            max_index_value = vv
          end
        end
        unless max_index_value.nil?
          left_value = max_index_value
          isize = max_index_value.index+1
        end
        value_array = value_array[Range.new(to_pick_range.end+1,value_array.size)]
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
      
