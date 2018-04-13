# no need to require thanks to bundler

class Iex
  include HTTParty

  base_uri "https://api.iextrading.com/1.0"

  format :json

  def initialize(symbol)
    @symbol = symbol
  end

  def info
    self.class.get("/stock/%s/company" % @symbol).parsed_response
  end

  def news
    self.class.get("/stock/%s/news" % @symbol).parsed_response
  end

 def earnings
    self.class.get("/stock/%s/earnings" % @symbol).parsed_response
  end


  def charts(range)

# /stock/aapl/chart
# /stock/aapl/chart/5y
# /stock/aapl/chart/2y
# /stock/aapl/chart/1y
# /stock/aapl/chart/ytd
# /stock/aapl/chart/6m
# /stock/aapl/chart/3m
# /stock/aapl/chart/1m
# /stock/aapl/chart/1d
    # A LO MEJOR PETA EL DOBLE %
    self.class.get("/stock/%s/chart/" % @symbol + range).parsed_response
  end

  def dividends(range)

# /stock/aapl/chart
# /stock/aapl/chart/5y
# /stock/aapl/chart/2y
# /stock/aapl/chart/1y
# /stock/aapl/chart/ytd
# /stock/aapl/chart/6m
# /stock/aapl/chart/3m
# /stock/aapl/chart/1m
# /stock/aapl/chart/1d
    # A LO MEJOR PETA EL DOBLE %
    self.class.get("/stock/%s/dividends/" % @symbol + range).parsed_response
  end

  def financials
    self.class.get("/stock/%s/financials" % @symbol).parsed_response
  end

  def quote
    self.class.get("/stock/%s/quote" % @symbol).parsed_response
  end

  def price
    self.class.get("/stock/%s/price" % @symbol).parsed_response
  end
  def stats
    self.class.get("/stock/%s/stats" % @symbol).parsed_response
  end
  def image_logo
    logo_json = self.class.get("/stock/%s/logo" % @symbol).parsed_response
    logo_json['url']
  end

end
