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

  def charts
    self.class.get("/stock/%s/chart/1m" % @symbol).parsed_response
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



end
