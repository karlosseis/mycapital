class Company < ActiveRecord::Base
include ActionView::Helpers::NumberHelper
include ActionView::Helpers::DateHelper
require 'settings.rb'  
  belongs_to :user
  belongs_to :stockexchange
  belongs_to :sector
  
  has_many :operations, dependent: :destroy
  has_many :expected_dividends
  has_many :expert_target_prices
  has_many :company_comments
  has_many :company_results


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

  def dividend_last_result 
    # Dividendo del úlitmo resultado guardado en la empresa

    res = self.company_results.order(year_result: :desc).limit(1) 
    div = 0  
    res.each do |p| 
       div = p.dividendo_ordinario
    end
    if div.nil? then 
      div = 0
    end
    div  
  end

  def perc_dividend_last_result
    perc_expected = 0
    unless self.stock_price==0 or self.stock_price.nil? 
      perc_expected = (self.dividend_last_result * 100) / self.stock_price
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
    unless @date_price.nil?
      date_price = I18n.l(@date_price)
    end

    date_price
  end

  def share_price_formatted
    number_to_currency(self.stock_price, unit:self.stockexchange.currency.symbol, seperator: ",", delimiter: ".")
  end

  def average_price_origin_currency_formatted
    number_to_currency(self.average_price_origin_currency, unit:self.stockexchange.currency.symbol, seperator: ",", delimiter: ".")
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

  def target_price_1_formatted
    number_to_currency(self.target_price_1, unit:self.stockexchange.currency.symbol, seperator: ",", delimiter: ".")

  end

  def target_price_2_formatted
    number_to_currency(self.target_price_2, unit:self.stockexchange.currency.symbol, seperator: ",", delimiter: ".")

  end

  def target_sell_price_formatted
    number_to_currency(self.target_sell_price, unit:self.stockexchange.currency.symbol, seperator: ",", delimiter: ".")

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
    if self.stockexchange.currency.name ==  Mycapital::CURRENCY_PURCHASE then
       total = self.stock_price
    else
      require 'money'
      require 'money/bank/google_currency'      
      bank = Money::Bank::GoogleCurrency.new
      
      begin
        total = self.stock_price * bank.get_rate(self.stockexchange.currency.name, Mycapital::CURRENCY_PURCHASE).to_f
        # la cotización de las acciones UK vienen en peniques y google currency  no tiene el tipo de cambio
        # por tanto, recuperamos la cotización en libras y dividimos por 100, que es lo mismo. 
        if self.stockexchange.currency.name == 'GBP' then
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
    
        uri =URI.parse('http://finance.google.com/finance/info?q=' + self.google_symbol)

        rs = Net::HTTP.get(uri)

        price = 0
        unless rs ==  "httpserver.cc: Response Code 400\n"
        
          rs.delete! '//'

          a = JSON.parse(rs) 

          @stock_price =  a[0]["l"] 
          @stock_price.sub!(',','')
          @var_price =  a[0]["c"] 
          @var_percent= a[0]["cp"] 
          @date_price= a[0]["lt_dts"].to_date 
          
        
          
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
    number_to_currency(@stock_price, unit:self.stockexchange.currency.symbol, seperator: ",", delimiter: ".")
  end

  def var_price_formatted
    number_to_currency(@var_price, unit:self.stockexchange.currency.symbol, seperator: ",", delimiter: ".")
  end  

  def var_percent
    @var_percent.to_f
  end

  def set_stock_price_google
   
        
        uri =URI.parse('http://finance.google.com/finance/info?q=' + self.google_symbol)

        rs = Net::HTTP.get(uri)
        unless rs ==  "httpserver.cc: Response Code 400\n"
        
          rs.delete! '//'

          a = JSON.parse(rs) 

          price = a[0]["l"]
          price.sub!(',','')  #le quito el . porque precios mayores de 1000 dan error (ej: 1,002.1)
          self.share_price =  price.to_f 
          self.date_share_price = a[0]["lt_dts"].to_f
          #self.set_update_summary
        end

    
  end

end