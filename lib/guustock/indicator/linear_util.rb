
module Guustock
  class LinearUtil

    def self.add_coef!(a, b, x)
      # a += b*x
      count = a.size()>b.size()?b.size():a.size()
      0.upto(count-1) do |i|
        a[i] += b[i] * x
      end
      count.upto(b.size()-1) do |i|
        a << (b[i]*x)
      end
    end


    def self.sub_coef!(a, b)
      # a-=b
      self.add_coef!(a, b, -1.0)
    end

    def self.ema_coef(n, origin_coef)
      size = origin_coef.size()+n-1
      coef = Array.new(size, 0.0)
      a = 2.0/(n+1)
      a1 = 1.0-a
      0.upto(origin_coef.size()-1) do |i|
        base = origin_coef[i]
        0.upto(n-1) do |j|
          o = coef[i+j]
          p = a1 ** j
          v = base*a*p
          coef[i+j] = o+v
        end
      end
      return coef
    end


    def self.macd_coef(fast, flow, signal)
      init = [1.0]
      emaf = self.ema_coef(fast, init)
      emas = self.ema_coef(flow, init)
      macd = emaf.clone
      self.sub_coef!(macd, emas)
      signal_coef = self.ema_coef(signal, macd)
      histogram = macd.clone
      self.sub_coef!(histogram, signal_coef)
      return histogram
    end

  end
end

