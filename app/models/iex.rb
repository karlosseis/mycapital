# no need to require thanks to bundler

class Iex
  include HTTParty

  #base_uri "https://api.iextrading.com/1.0"
  base_uri "https://cloud.iexapis.com/beta"
  

  #https://api.iextrading.com/1.0/stock/t/dividends/1y

  format :json

  def initialize(symbol)
    @symbol = symbol

    # 18/11/2021    
    #angulo.carlos
    @secret_token = "sk_a869f8d2eba140728de5380d3b971899"


    # 21/10/2021
    #corotos
    #@secret_token = "sk_0af9b76d64e744eb99d90e8f8a525da6"
    
  end

  def info
    self.class.get("/stock/%s/company" % @symbol + "?token=" + @secret_token).parsed_response
    #self.class.get("/stock/%s/company" % @symbol + "?token=" + @secret_token).parsed_response
  end

  def news
    self.class.get("/stock/%s/news" % @symbol + "?token=" + @secret_token).parsed_response
  end

 def earnings
    self.class.get("/stock/%s/earnings" % @symbol + "?token=" + @secret_token).parsed_response
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
    self.class.get("/stock/%s/chart/" % @symbol + range + "?token=" + @secret_token).parsed_response
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
    self.class.get("/stock/%s/dividends/" % @symbol + range  + "?token=" + @secret_token).parsed_response
  end

def dividends_batch()

    self.class.get("/stock/market/batch?symbols=%s" % @symbol  + "&types=dividends&token=" + @secret_token).parsed_response
  end

  def financials
    self.class.get("/stock/%s/financials" % @symbol + "?token=" + @secret_token).parsed_response
  end

  def quote
    self.class.get("/stock/%s/quote" % @symbol + "?token=" + @secret_token).parsed_response
  end

  def price
    self.class.get("/stock/%s/price" % @symbol + "?token=" + @secret_token).parsed_response
  end
  def stats
    self.class.get("/stock/%s/stats" % @symbol + "?token=" + @secret_token).parsed_response
  end
  def image_logo
    logo_json = self.class.get("/stock/%s/logo" % @symbol + "?token=" + @secret_token).parsed_response
    logo_json['url']
  end

end
