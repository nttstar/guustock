require_relative "../common/bar.rb"
require_relative "../common/config.rb"
require 'tokyocabinet'
include TokyoCabinet

module Guustock

  class BarDb
    attr_reader :is_open

    def initialize(path)
      @path = path
      @bdb = BDB::new
      @bdb_in = BDB::new
      @bdb_ni = BDB::new
      @is_open = false
    end


    @@instance = BarDb.new(Config::db_path)

    def self.instance
      if !@@instance.is_open
        @@instance.open
      end
      return @@instance
    end

    def self.raw_period
      return 5
    end

    def open
      if !File.exist? @path
        Dir.mkdir(@path)
      end
      if !@bdb.open(@path+"/bar", BDB::OWRITER | BDB::OCREAT)
        ecode = @bdb.ecode
        STDERR.printf("open error: %s\n", @bdb.errmsg(ecode))
        false
      end
      if !@bdb_in.open(@path+"/in", BDB::OWRITER | BDB::OCREAT)
        ecode = @bdb_in.ecode
        STDERR.printf("open error: %s\n", @bdb_in.errmsg(ecode))
        false
      end
      if !@bdb_ni.open(@path+"/ni", BDB::OWRITER | BDB::OCREAT)
        ecode = @bdb_ni.ecode
        STDERR.printf("open error: %s\n", @bdb_ni.errmsg(ecode))
        false
      end
      @is_open = true
      true
    end
    
    def close
      if !@bdb.close
        ecode = @bdb.ecode
        STDERR.printf("close error: %s\n", @bdb.errmsg(ecode))
      end
      if !@bdb_in.close
        ecode = @bdb_in.ecode
        STDERR.printf("close error: %s\n", @bdb_in.errmsg(ecode))
      end
      if !@bdb_ni.close
        ecode = @bdb_ni.ecode
        STDERR.printf("close error: %s\n", @bdb_ni.errmsg(ecode))
      end
      @is_open = false
    end
    
    def flush
      if !@bdb.sync
        ecode = @bdb.ecode
        STDERR.printf("sync error: %s\n", @bdb.errmsg(ecode))
      end
      if !@bdb_in.sync
        ecode = @bdb_in.ecode
        STDERR.printf("sync error: %s\n", @bdb_in.errmsg(ecode))
      end
      if !@bdb_ni.sync
        ecode = @bdb_ni.ecode
        STDERR.printf("sync error: %s\n", @bdb_ni.errmsg(ecode))
      end
    end
    
    def insert_name(id, name)
      @bdb_in.put(id, name)
      @bdb_ni.put(name, id)
    end
    
    def insert(bar)
      key = bar.get_key
      value = bar.get_value
      #puts "insert #{bar.time}"
      #puts "key #{key}"
      if !@bdb.put(key, value)
        ecode = @bdb.ecode
        STDERR.printf("put error: %s\n", @bdb.errmsg(ecode))
      end
    end
    
    def get(id, time)
      key = Bar.get_key_impl(id, time)
      value = @bdb.get(key)
      
      if value
        bar = Bar.new(id, time)
        bar.parse_value(value)
        return bar
      else
        STDERR.printf("Bar not find: %s\n", key)
        nil
      end
    end

    def each_stock
      cur = BDBCUR.new(@bdb_in)
      return if !cur.first()
      loop do
        yield cur.key(), cur.val()
        break if !cur.next()
      end
    end

    def forward_each(id, time)
      cur = BDBCUR.new(@bdb)
      key = Bar.get_key_impl(id, time)
      return if !cur.jump(key)
      first_key = cur.key()
      #if first_key!=key
      #  if !cur.prev()
      #    return
      #  end
      #end
      loop do
        ckey = cur.key()
        cvalue = cur.val()
        break if ckey.nil?
        break if cvalue.nil?
        bar = Bar.parse(ckey, cvalue)
        break if bar.id!=id
        #puts "XXXX#{bar}"
        yield bar
        break if !cur.next()
      end
   
    end

    def backward_each(id, time)
      cur = BDBCUR.new(@bdb)
      key = Bar.get_key_impl(id, time)
      return if !cur.jump(key)
      first_key = cur.key()
      if first_key!=key
        if !cur.prev()
          return
        end
      end
      loop do
        ckey = cur.key()
        cvalue = cur.val()
        break if ckey.nil?
        break if cvalue.nil?
        bar = Bar.parse(ckey, cvalue)
        break if bar.id!=id
        yield bar
        break if !cur.prev()
      end
   
    end
  end
end

