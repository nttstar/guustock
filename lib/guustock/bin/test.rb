#!/usr/bin/env ruby
require 'logger'
require_relative '../indicator/indicator_viewer'
require_relative '../db/bar_db'
$stdout.sync = true

include Guustock
id = ARGV[0]
exit(-1) if id.nil?
viewer = IndicatorViewer.new("fenxing")
viewer.view(id, [5], Time.mktime(2007, 7, 2), Time.mktime(2007,7,30))
viewer.bar_sequence.each do |bars|
  bar = bars[0]
  puts bar
end

#bar_db = BarDb.instance
#puts Time.now
#count = 0
#bar_db.forward_each(id, Time.new(2001)) do |bar|
  #count += 1
  ##p bar
#end
#puts "count:#{count}"
#puts Time.now
