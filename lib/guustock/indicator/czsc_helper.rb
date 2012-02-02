require_relative '../common/bar.rb'

module Guustock

  BAR_CONTAINS = 1
  BAR_BE_CONTAINED = 2
  BAR_HIGHER = 3
  BAR_LOWER = 4
  BAR_EQUAL = 5
  class Bar
    def relation(other_bar)
      if @high>other_bar.high
        if @low<=other_bar.low
          return BAR_CONTAINS
        else
          return BAR_HIGHER
        end
      elsif @high==other_bar.high
        if @low<other_bar.low
          return BAR_CONTAINS
        elsif @low==other_bar.low
          return BAR_EQUAL
        else 
          return BAR_BE_CONTAINED
        end
      else
        if @low<other_bar.low
          return BAR_LOWER
        else
          return BAR_BE_CONTAINED
        end
      end
    end

    def append_merge(bar_list, new_bar)
    end
  end

end

