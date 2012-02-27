
module Guustock

  class BarArray < Array

    attr_accessor :isize

    def initialize
      super
      @isize = Hash.new(0)
    end

  end

end

