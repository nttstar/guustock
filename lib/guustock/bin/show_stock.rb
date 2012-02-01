#!/usr/bin/env ruby
require 'logger'
require_relative '../db/bar_db.rb'
$stdout.sync = true

include Guustock
db = BarDb.instance
db.each_stock do |id, name|
  puts "#{id} - #{name}"
end

