class Company < ActiveRecord::Base
include ActionView::Helpers::NumberHelper
include ActionView::Helpers::DateHelper
require 'settings.rb'  
  belongs_to :user
  belongs_to :stockexchange
  belongs_to :sector
  
  has_many :operations, dependent: :destroy
  has_many :expected_dividends
  #has_many :expert_target_prices
  has_many :company_comments
  has_many :company_results
  has_many :company_historic_dividends


  validates :name, presence: true
  validates :symbol, presence: true
  validates :stockexchange, presence: true
  #validates :sector, presence: true
  validates :search_symbol, presence: true
  
  enum traffic_light_id: {rojo: 1, amarillo: 2, verde: 3, gris: 0}
  

  accepts_nested_attributes_for :operations,reject_if: proc { |attributes| attributes['amount'].blank? }
  
  @stock_price = 0
  @var_price = 0
  @var_percent = 0
  @date_price = ''

  after_find :get_stock_price_google

  def self.search(search)

   if search 
    
      if Rails.env.production?
       where('name ILIKE ?', "%#{search}%")
      else
        where('name LIKE ?', "%#{search}%")
      end

    else

      scoped

    end

  end




  def get_google_finance_data
    get_stock_price_google
  end


  def to_s
    name
  end  

  def get_id
    id    
  end




  def perc_dividend_last_result
    perc_expected = 0
    unless self.stock_price==0 or self.stock_price.nil? or self.dividend_last_result ==0 or self.dividend_last_result.nil?
      perc_expected = (self.dividend_last_result * 100) / self.stock_price
    end
    perc_expected
  end

  def perc_estimated_year_dividend_amount
    perc_expected = 0
    unless self.stock_price==0 or self.stock_price.nil? or self.estimated_year_dividend_amount ==0 or self.estimated_year_dividend_amount.nil?
      perc_expected = (self.estimated_year_dividend_amount * 100) / self.stock_price
    end
    perc_expected
  end

  def  date_share_price_time_ago
    date_price = ""
    unless @date_price.nil?
      date_price = "Hace " + time_ago_in_words(date_share_price)
    end

    date_price
  end

  def  date_share_price_formatted
    date_price = ""
    unless @date_price.nil? or @date_price == ""
      date_price = I18n.l(@date_price)
    end

    date_price
  end

  def share_price_formatted
    number_to_currency(self.stock_price, unit:self.stockexchange_currency_symbol, seperator: ",", delimiter: ".")
  end

  def average_price_origin_currency_formatted
    number_to_currency(self.average_price_origin_currency, unit:self.stockexchange_currency_symbol, seperator: ",", delimiter: ".")
  end

  def google_symbol
     prefix = ""

     unless Settings.google_prefixes.nil?
         prefix = Settings.google_prefixes[self.stockexchange_id]
     end

    # unless self.stockexchange.google_prefix.nil?
    #   prefix = self.stockexchange.google_prefix
    # end
    prefix + self.symbol
    
  end
  
  def yahoo_symbol
     suffix = ""

     unless Settings.yahoo_suffixes.nil?
         suffix = Settings.yahoo_suffixes[self.stockexchange_id]
     end


    self.symbol + suffix
    
  end

  def url_google_finance
    "https://www.google.com/finance?q=" + self.google_symbol
  end

  def last_purchase
      op = self.operations.where(operationtype_id: Mycapital::OP_PURCHASE).order(operation_date: :desc).limit(1) 
      price = ""
      date_purchase = ""
      #currency_symbol = ""

      op.each do |p| 
          price =   number_to_currency(p.origin_price, unit:p.currency.symbol, seperator: ",", delimiter: ".")
          date_purchase = I18n.l(p.operation_date)
          #currency_symbol  = p.currency.symbol 
      end
      ret = { a: price, b: date_purchase}   
     
      ret
  end

  def next_dividend
    # ordenamos ascendente para que salga el próximo, sino saldría el último del año. 
    div = self.expected_dividends.where('operation_date >= ?', (Time.now).beginning_of_day).order(operation_date: :asc).limit(1) 
    amount = ""
    date_dividend = ""

      div.each do |p| 
          amount = number_to_currency(p.amount)
          date_dividend = I18n.l(p.operation_date)
      end
      ret = { a: amount, b: date_dividend}   
     
      ret


  end

  def expected_yoc
    
    total_expected = self.expected_dividends.where(:operationtype_id => Mycapital::OP_DIVIDEND).sum(:amount)
    unless invested_sum==0
      perc_expected = (total_expected * 100) / invested_sum
    end
    perc_expected
  end

  def dif_target_price 
    self.stock_price - self.target_price_1
  end

  def dif_target_sell_price 
    ret = 99999
    unless self.target_sell_price.nil?
      ret = self.stock_price - self.target_sell_price
    end
    ret
  end

  def target_price_1_formatted
    number_to_currency(self.target_price_1, unit:self.stockexchange_currency_symbol, seperator: ",", delimiter: ".")

  end

  def target_price_2_formatted
    number_to_currency(self.target_price_2, unit:self.stockexchange_currency_symbol, seperator: ",", delimiter: ".")

  end

  def target_sell_price_formatted
    number_to_currency(self.target_sell_price, unit:self.stockexchange_currency_symbol, seperator: ",", delimiter: ".")

  end

  

  def porc_dif_target_sell_price    
    perc_result = 0 
    unless self.dif_target_sell_price >= 0
      perc_result = (self.dif_target_sell_price * 100) / self.stock_price
    end
    perc_result    
  end

  def porc_dif_target_price    
    perc_result = 0 
    unless self.dif_target_price<=0
      perc_result = (self.dif_target_price * 100) / self.stock_price
    end
    perc_result    
  end

  def share_price_global_currency 
    # share prices in currency purchases (ie, all the operations are bought in euros, 
    # the currency will be euros)
    total = 0
    if self.stockexchange_currency_name ==  Mycapital::CURRENCY_PURCHASE then
       total = self.stock_price
    else
      require 'money'
      require 'money/bank/google_currency'      
      bank = Money::Bank::GoogleCurrency.new
      
      begin ## ESTE BEGIN DEBERÍA IR AL PRINCIPIO, PARA CUANDO NO TENGO INTERNET
        total = self.stock_price * bank.get_rate(selfstockexchange_currency_name, Mycapital::CURRENCY_PURCHASE).to_f
        # la cotización de las acciones UK vienen en peniques y google currency  no tiene el tipo de cambio
        # por tanto, recuperamos la cotización en libras y dividimos por 100, que es lo mismo. 
        if self.stockexchange_currency_name == 'GBP' then
          total = total / 100
        end
      rescue  
        total = 0
      end
    
    end
    unless total.nil?
        total.round(2)
    end
    
  end



  def set_perc_estimated_benefit_global_currency  
    # porcentaje de beneficio en base al valor estimado actual en la moneda de la aplicación (EUROS)
   
    total = 0
    unless invested_sum == 0 then
        total = estimated_benefit_global_currency.to_f * 100 / invested_sum.to_f
    end
    self.perc_estimated_benefit_global_currency = total.round(2)
  end

  def set_estimated_benefit_global_currency 
    # beneficio estimado en la moneda de la aplicación (EUROS)
    total = estimated_value_global_currency.to_f - invested_sum.to_f
    self.estimated_benefit_global_currency = total.round(2)
    self.set_perc_estimated_benefit_global_currency()
  end

   def set_estimated_value_global_currency
    # valor estimado de las acciones en compania en la moneda de la aplicación (EUROS)
     total = share_price_global_currency.to_f * shares_sum
     self.estimated_value_global_currency= total.round(2)
     self.set_estimated_benefit_global_currency()
   end

   def estimated_value_global_currency_now
     share_price_global_currency.to_f * shares_sum
   end

   def estimated_benefit_global_currency_now
    # beneficio estimado tomando el precio actual de google finance y no el guardado en bdd

    total = estimated_value_global_currency_now - invested_sum.to_f
    total.round(2)
    #self.set_perc_estimated_benefit_global_currency()

   end

  def perc_estimated_benefit_global_currency_now  
    # porcentaje de beneficio en base al valor estimado actual en la moneda de la aplicación (EUROS)
   
    total = 0
    unless invested_sum == 0 then
        total = estimated_benefit_global_currency_now.to_f * 100 / invested_sum.to_f
    end
    total.round(2)
  end


  def set_average_price 
    # precio medio de la acción en base a las compras realizadas (moneda de la aplicación, EUROS)
      total = 0
      total_real = 0        
      self.operations.where.not(:operationtype_id => Mycapital::OP_DIVIDEND).each do |op| 
        unless op.price.nil? || op.quantity.nil?

          if op.operationtype_id == Mycapital::OP_SALE 
            # si es una venta tenemos que restarle el valor del importe
            total = total - (op.price *  op.quantity)
            total_real = total_real - op.amount
          else
            total = total + (op.price *  op.quantity)
            total_real = total_real + op.amount
          end
        end
        
      end    
      unless self.shares_sum == 0 
        total = total / self.shares_sum   
        total_real = total_real / self.shares_sum   
      end 
      self.average_price = total.round(2)
      self.average_price_real = total_real.round(2)

      # (# compra 1 * precio 1) + (# compra 2*precio 2) + (# venta 1*precio1) + (# ampliacion 1*precio1)/ (#compra1 + #compra2 + # venta 1 +  # ampliacion 1)
      # hay que tener en cuenta las ventas y también las ampliaciones
  end

  def set_shares_sum
    # total de acciones
    self.shares_sum = (quantity_puchased.to_i - quantity_sold.to_i + quantity_ampliated.to_i).round(0)
    self.set_estimated_value_global_currency()
  end


  def set_invested_sum 
    # total invertido actualmente, es decir, compras menos ventas en lamoneda de la aplicación (euros) + las ampliaciones, que también pueden costar dinero
    # hace cambiar el precio medio de la acción y el beneficio estimado
     self.invested_sum = puchased_sum.to_f - sold_sum.to_f + ampliated_sum.to_f
     self.set_average_price()
     self.set_estimated_benefit_global_currency()
  end 


  def set_dividend_sum   
    total = self.operations.where(:operationtype_id => Mycapital::OP_DIVIDEND).sum(:net_amount)
    self.dividend_sum   = total.round(2)
  end

  def set_puchased_sum 
    total = self.operations.where(:operationtype_id => Mycapital::OP_PURCHASE).sum(:amount)
    self.puchased_sum = total.round(2)
    self.quantity_puchased = self.operations.where(:operationtype_id => Mycapital::OP_PURCHASE).sum(:quantity)
    self.set_shares_sum()
    self.set_invested_sum()
  end

  def set_sold_sum  
      total = self.operations.where(:operationtype_id => Mycapital::OP_SALE).sum(:amount)
      self.sold_sum  = total.round(2)
      self.quantity_sold = self.operations.where(:operationtype_id => Mycapital::OP_SALE).sum(:quantity)
      self.set_shares_sum()
      self.set_invested_sum()
  end

  def set_ampliated_sum  
      total = self.operations.where(:operationtype_id => Mycapital::OP_AMPLIATION).sum(:amount)
      self.ampliated_sum  = total.round(2)
      self.quantity_ampliated = self.operations.where(:operationtype_id => Mycapital::OP_AMPLIATION).sum(:quantity)
      self.set_shares_sum()
  end

  # Por acabar
  def set_average_price_origin_currency
      total = 0  
      total_real = 0       
      self.operations.where.not(:operationtype_id => Mycapital::OP_DIVIDEND).each do |op| 
        unless op.origin_price.nil? || op.quantity.nil?
          exchange_to_origin_price = 0  
          unless op.exchange_rate ==0   
             # calculamos la tasa a aplicar para convertir de EUR a USD porque la que tenemos guardada es de USD a EUR
             exchange_to_origin_price = 1 / op.exchange_rate
          end
          if op.operationtype_id == Mycapital::OP_SALE 
            # si es una venta tenemos que restarle el valor del importe
            total = total - (op.origin_price *  op.quantity)
            total_real = total_real - (op.amount *  exchange_to_origin_price)
          else
            total = total + (op.origin_price *  op.quantity)
            total_real = total_real + (op.amount *  exchange_to_origin_price)
          end
        end
        
      end    
      unless self.shares_sum == 0 
        total = total / self.shares_sum   
        total_real = total_real / self.shares_sum   
      end 
      self.average_price_origin_currency = total.round(2)
      self.average_price_origin_currency_real = total_real.round(2)


      # (# compra 1 * precio 1) + (# compra 2*precio 2) + (# venta 1*precio1) + (# ampliacion 1*precio1)/ (#compra1 + #compra2 + # venta 1 +  # ampliacion 1)
      # hay que tener en cuenta las ventas y también las ampliaciones
  end

  def set_update_summary ()
    #operationtype_id
    # updateamos todas los campos del resumen: total invertido, dividendos, beneficios estimados...

    # case :operationtype_id
    # when Mycapital::OP_DIVIDEND then self.set_dividend_sum()
    # when Mycapital::OP_PURCHASE then self.set_puchased_sum()
    # when Mycapital::OP_SALE then  self.set_sold_sum()
    # when Mycapital::OP_AMPLIATION then  self.set_ampliated_sum()
    # end

    self.set_dividend_sum()
    self.set_puchased_sum()
    self.set_sold_sum()
    self.set_ampliated_sum()


    self.set_average_price_origin_currency()    

    
    #total.round(2)

  end

  def set_last_result_values 
    # guardamos en la cabecera de la empresa datos del último resultado: payout, número acciones...

    res = self.company_results.order(year_result: :desc).limit(1) 
    div = 0  
    res.each do |p| 
       self.payout = p.payout
       self.shares_quantity = p.num_acciones
       self.dividend_last_result = p.dividendo_ordinario

    end
  
  end

  def set_next_official_dividend_values 
    # guardamos en la cabecera de la empresa datos del próximo dividendo anunciado por la empresa y el estimado para este año

    res = self.company_historic_dividends.where('payment_date >= ?',Time.now.beginning_of_day).order(payment_date: :asc).limit(1) 
        
    div = 0  
    res.each do |p| 
       self.next_dividend_date = p.payment_date
       self.next_dividend_amount = p.amount       
    end

    res = self.company_historic_dividends.where('exdividend_date >= ?',Time.now.beginning_of_day).order(exdividend_date: :asc).limit(1) 
        
    div = 0  
    res.each do |p| 
       self.next_exdividend_date = p.exdividend_date     
    end

    # recuperamos los últimox X dividendos (donde X es el número de pagos anuales de la empresa)
    @last_divs = self.company_historic_dividends.select(:amount, :dividend_type).where("amount > ?", 0).order(payment_date: :desc)
    
    @total_amount = 0 
    @contador = 0
    @last_divs.each do |a|      
      if a.ordinario?
        @total_amount = @total_amount + a.amount  
        @contador = @contador + 1 
      end
      if @contador == self.dividend_payments_quantity
        break
      end
    end
    self.estimated_year_dividend_amount = @total_amount

  
  end

  def set_stock_price
      
      date_last_week = Time.new
      date_last_week = date_last_week - 7.days
      date_today = Time.new
      
      # recuperamos la cotización del día anterior (yahoo no ofrece la del día actual para empresas españolas)
      # chapuza mode ON. Fuerzo a que siempre devuelva algo pidiendo las cotizaciones de la última semana.
      # Esto es porque no hay manera de saber si no devuelve nada, ya que cuando no devuelve se debe hacer con 
          # @stock.failure?

          # pero cuando devuelve datos el método da error.
      # 08.03.2017 - Aun así, si la empresa no cotiza desde hace mucho, el history no recupera nada y peta (ej. GOWEX). Pongo control de errores
    begin
    @stock = StockQuote::Stock.history(self.search_symbol, date_last_week.strftime("%Y-%m-%d"),  date_today.strftime("%Y-%m-%d"))
   
        
      @stock.each do  |x| 
        unless x.nil?
         self.share_price =  x.high.round(2)
         self.date_share_price = x.date         
        end

        break   # como el primer dato es la fecha mayor (la que quiero), salgo la primera vez que entro.
      end
        # chapuza mode OFF


        # hay que guardar también la fecha
        # montar un proceso que lea todas las empresas y guardar fecha y precio 
        self.set_update_summary
        #self.save
    rescue

    end
  end

  def get_stock_price_google
      begin
        #uri =URI.parse('http://finance.google.com/finance/info?q=' + self.google_symbol)

        if Settings.yahoo_suffixes[self.stockexchange_id] == ".MC"
          # si es el mercado continuo buscamos por google pq yahoo sólo tiene datos históricos

          uri =URI.parse('http://finance.google.com/finance?q=' + self.google_symbol + '&output=json')

          rs = Net::HTTP.get(uri)

          price = 0
          unless rs ==  "httpserver.cc: Response Code 400\n"
          
            rs.delete! '//'

            a = JSON.parse(rs) 

            @stock_price =  a[0]["l"] 
            @stock_price.sub!(',','')
            @var_price =  a[0]["c"] 
            @var_percent= a[0]["cp"] 
            @date_price = ""
            unless a[0]["lt_dts"].nil?
              @date_price= a[0]["lt_dts"].to_date 
            end
          end
        else
          stocks = StockQuote::Stock.quote(self.yahoo_symbol)
          #if stocks.success? # en el log sale que está deprecated
            @stock_price = stocks.last_trade_price_only
            @var_price = stocks.change           
            @var_percent = stocks.percent_change
            @date_price = ""
            unless stocks.last_trade_date.nil?
              @date_price= DateTime.strptime(stocks.last_trade_date, '%m/%d/%Y')
            end            
            
          #end
        end   
          
        

       rescue
          @stock_price = 0          
          @var_price =  0
          @var_percent= 0
          @date_price= ''
       end
       price
  end


  def stock_price
    @stock_price.to_f
  end

  def var_price
     @var_price.to_f
  end

  def stock_price_formatted
    number_to_currency(@stock_price, unit:self.stockexchange_currency_symbol, seperator: ",", delimiter: ".")
  end

  def var_price_formatted
    number_to_currency(@var_price, unit:self.stockexchange_currency_symbol, seperator: ",", delimiter: ".")
  end  

  def var_percent
    @var_percent.to_f
  end

  def set_stock_price_google
   
        # k = Company.find(34)
        # k.set_stock_price_google
        #uri =URI.parse('http://finance.google.com/finance/info?q=' + self.google_symbol)
        #https://finance.google.com/finance?q=T&output=json
        uri =URI.parse('http://finance.google.com/finance?q=' + self.google_symbol + '&output=json')

        rs = Net::HTTP.get(uri)
        unless rs ==  "httpserver.cc: Response Code 400\n"
        
          rs.delete! '//'

          a = JSON.parse(rs) 

          price = a[0]["l"]
          price.sub!(',','')  #le quito el . porque precios mayores de 1000 dan error (ej: 1,002.1)
          self.share_price =  price.to_f 
          #self.date_share_price = a[0]["lt_dts"].to_f
          self.set_update_summary
        end

    
  end

  def years_with_dividend
    ret = 0
    unless self.first_uninterrupted_year_div.nil? or self.first_uninterrupted_year_div == 0 
      ret = Date.today.year - self.first_uninterrupted_year_div
    end
    ret
  end


  def is_aristocrat
    self.years_with_dividend  > 25
  end

  def market_cap
    total = self.shares_quantity * self.stock_price
    if self.stockexchange_currency_symbol == 'p' then
          total = total / 100
    end
    total
  end

  def stockexchange_currency_symbol
   
     currency_symbol = "X"
    
      unless Settings.stockexchange_currency_symbol.nil?
         currency_symbol = Settings.stockexchange_currency_symbol[self.stockexchange_id]
      end

    currency_symbol
   
  end

  def stockexchange_currency_name
   
     currency_name = "Y"
    
      unless Settings.stockexchange_currency_name.nil?
         currency_name = Settings.stockexchange_currency_name[self.stockexchange_id]
      end

    currency_name
   
  end

end