#!/usr/bin/env ruby
require 'bindata'
require 'logger'
require 'iconv'
require 'fileutils'
require_relative 'bar_db'

include Guustock

class BarDbImporter
  def initialize(path)
    @db = BarDb.new(path)
    if !@db.open
      raise "db can not open : #{path}"
    end
    @logger = Logger.new(STDOUT)
  end
  
  def add_qm5_file(file, start_time, end_time)
    @logger.info "start_time : #{start_time}"
    @logger.info "end_time : #{end_time}"
    time_diff = -1*8*3600
    is = File.open(file, "rb")
    cd = Iconv.new("utf-8", "gb2312")
    obj_int = BinData::Int32le.new
    obj_float = BinData::FloatLe.new
    obj_int.read(is)
    flag1 = obj_int.to_i
    obj_int.read(is)
    flag2 = obj_int.to_i
    obj_int.read(is)
    stock_num = obj_int.to_i
    @logger.info "Total stock number : #{stock_num}"
    stock_num.times do |snum|
      if snum%10 == 0
        @logger.info "Processing stock number : #{snum}"
      end
      id = is.read(12).strip
#       puts "id : #{id}"
      oname = is.read(12).strip();
      name = ""
      begin
        name = cd.iconv(oname).strip()
      rescue
        @logger.warn "iconv error #{oname}"
        name = oname
      end
#       puts "id : #{id}, name #{name}"
      @db.insert_name(id, name)
      obj_int.read(is)
      bar_num = obj_int
      bar_num.times do |bnum|
#         if bnum%10000 == 0
#           puts "Processing bar number : #{bnum}"
#         end
        obj_int.read(is)
        itime = obj_int.to_i
        itime += time_diff
#         puts "itime : #{itime}"
        time = Time.at(itime)
        obj_float.read(is)
        open = obj_float.to_f
        obj_float.read(is)
        high = obj_float.to_f
        obj_float.read(is)
        low = obj_float.to_f
        obj_float.read(is)
        close = obj_float.to_f
        obj_float.read(is)
        amount = obj_float.to_f
        obj_float.read(is)
        vol = obj_float.to_f
        obj_int.read(is)
        change = obj_int.to_i
#         puts time
        
        bar = Bar.new(id, time, open, high, low, close, vol)
        if !time_valid(time, start_time, end_time)
          #puts "Invalid bar time : #{bar}"
          next
        end
        @db.insert(bar)
      end
                   
    end

    is.close
  end
  
  def close
    @db.close
  end
  
  private
  def time_valid(time, start_time, end_time)
    t = time.to_i
    st = start_time.to_i
    et = end_time.to_i
    if t>=st and t<et
      return true
    end
    return false
  end
end

bar_db_path = "./bar_db.bdb"
if File.exist?(bar_db_path)
  if File.file? bar_db_path
    File.delete bar_db_path
  else
    FileUtils.rm_rf bar_db_path
  end
end
importer = BarDbImporter.new bar_db_path
importer.add_qm5_file "/home/jarvis/data/stock-5min/200401-200512", Time.mktime(2004,01,01), Time.mktime(2006,01,01)
importer.add_qm5_file "/home/jarvis/data/stock-5min/200601-200712", Time.mktime(2006,01,01), Time.mktime(2008,01,01)
importer.add_qm5_file "/home/jarvis/data/stock-5min/200801-200912", Time.mktime(2008,01,01), Time.mktime(2010,01,01)
importer.add_qm5_file "/home/jarvis/data/stock-5min/201001-201011", Time.mktime(2010,01,01), Time.mktime(2010,12,01)
importer.add_qm5_file "/home/jarvis/data/stock-5min/201012", Time.mktime(2010,12,01), Time.mktime(2011,01,01)
importer.close
