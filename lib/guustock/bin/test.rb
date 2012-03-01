#!/usr/bin/env ruby
require 'logger'
require_relative '../indicator/indicator_viewer'
$stdout.sync = true

include Guustock
id = ARGV[0]
viewer = IndicatorViewer.new("fenxingk")
viewer.view(id, [5,30], Time.mktime(2005, 6, 1), Time.mktime(2005,7,1))


