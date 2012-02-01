#!/usr/bin/env ruby
require 'logger'
require_relative '../indicator/indicator_viewer'
require_relative '../indicator/macd_indicator'
$stdout.sync = true

include Guustock
macd = MacdIndicator.new
id = ARGV[0]
viewer = IndicatorViewer.new(macd, true)
viewer.view(id, Time.mktime(2000, 12, 1), [5, 15])


