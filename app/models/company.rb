class Company < ActiveRecord::Base
include ActionView::Helpers::NumberHelper
include ActionView::Helpers::DateHelper
require 'settings.rb'  
  belongs_to :user
  belongs_to :stockexchange
  belongs_to :sector
  belongs_to :broker
  
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

  after_find :get_stock_price

  def self.search(search)

   if search 
      # 21.01.2018 - comento porque ahora en local también tengo postgres
      #if Rails.env.production?
      # where('name ILIKE ?', "%#{search}%")
      #else
      #  where('name LIKE ?', "%#{search}%")
      #end
      # 11.02.2018 todo mysql
      where('name LIKE ?', "%#{search}%")


    else

      scoped

    end

  end


  # def get_google_finance_data
  #   get_stock_price
  # end


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

  def share_price_formatted  # REVISADO. NADA QUE REVISAR
    number_to_currency(self.stock_price, unit:self.stockexchange_currency_symbol, seperator: ",", delimiter: ".")
  end

  def average_price_origin_currency_formatted
    number_to_currency(self.average_price_origin_currency, unit:self.stockexchange_currency_symbol, seperator: ",", delimiter: ".")
  end

  def google_symbol # REVISADO. NADA QUE REVISAR
     prefix = ""

     unless Settings.google_prefixes.nil?
         prefix = Settings.google_prefixes[self.stockexchange_id]
     end

    # unless self.stockexchange.google_prefix.nil?
    #   prefix = self.stockexchange.google_prefix
    # end
    prefix + self.symbol
    
  end
  
  def yahoo_symbol # REVISADO. NADA QUE REVISAR
     suffix = ""

     unless Settings.yahoo_suffixes.nil?
         suffix = Settings.yahoo_suffixes[self.stockexchange_id]
     end


    self.symbol + suffix
    
  end

  def url_google_finance
    # "https://www.google.com/finance?q=" + self.google_symbol
    "https://finance.google.com/finance?q=" + self.google_symbol
    
  end

  def last_purchase
      op = self.operations.where(operationtype_id: Mycapital::OP_PURCHASE).order(operation_date: :desc).limit(1) 
      price = ""
      date_purchase = ""
 

      op.each do |p| 
          if self.currency_symbol_operations.to_s == Mycapital::CURRENCY_PURCHASE_SYMBOL.to_s   then 
            # si la compra es en euros, hay que coger el precio origen       
            price =   number_to_currency(p.origin_price, unit:p.currency.symbol, seperator: ",", delimiter: ".")
          else
            # sino, el precio de compra normal
            price =   number_currency_operations(p.price)
          end
          date_purchase = I18n.l(p.operation_date)
         
      end
      ret = { a: price, b: date_purchase}   
     
      ret
  end

  def next_dividend
    # ordenamos ascendente para que salga el próximo, sino saldría el último del año. 
    # devuelve el importe total del dividendo a cobrar  (div * número acciones)
    div = self.expected_dividends.where('operation_date >= ?', (Time.now).beginning_of_day).order(operation_date: :asc).limit(1) 
    amount = ""
    date_dividend = ""

      div.each do |p| 
          amount = number_currency_operations(p.amount)
          date_dividend = I18n.l(p.operation_date)
      end
      ret = { a: amount, b: date_dividend}   
     
      ret

  end

  def pendiente_incluir_dividendo_previsto?

      !self.nearest_announce_date.nil?
      # resultado = false
      # hay_datos = false
      # if self.next_dividend_date.nil? or self.next_dividend_date < Date.today
      #   # si no tengo próximo dividendo, buscamos si el año pasado se anunció el dividendo en estas fechas. 
      #   # Para ello busco historico menor al año pasado
      #   div = self.company_historic_dividends.where('announce_date <= ?', (Time.now).beginning_of_day - 12.month).order(announce_date: :desc).limit(5)       
      #   div.each do |p|     
      #       # si encuentra, miro que se anunciara como muy tarde un mes antes
      #       # P.ej, estamos a 20.09.2017. Si el dividendo se anunció el
      #       #     30.08.2016 - debe salir
      #       #     30.07.2016 - no debe salir pq considero que ya se ha cobrado uno después
      #       #                 
      #       if  p.announce_date  >=     (Time.now).beginning_of_day - 13.month  
      #         resultado = true
      #       end
      #       hay_datos = true
      #   end
      #   if !hay_datos
      #     # si no hay datos de historico de dividendos es que no los he puesto nunca y debo revisarlos
      #       resultado = true
      #   end
      
      # end
        
      # resultado

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

  def share_price_global_currency  # REVISADO OK
    # precio de la acción en la moneda global de compra (EUROS)
    total = 0
    if self.stockexchange_currency_name ==  Mycapital::CURRENCY_PURCHASE then
       total = self.stock_price
    else
      require 'money'
      require 'money/bank/google_currency'      
      bank = Money::Bank::GoogleCurrency.new
      
      begin ## ESTE BEGIN DEBERÍA IR AL PRINCIPIO, PARA CUANDO NO TENGO INTERNET
        total = self.stock_price * bank.get_rate(self.stockexchange_currency_name, Mycapital::CURRENCY_PURCHASE).to_f
      rescue  
        total = 0
      end
    
    end
    unless total.nil?
        total.round(2)
    end
    
  end
 

   def set_estimated_values  # REVISADO NUEVO
     # valor, beneficio y porcenteje de beneficio en la moneda de las operaciones de la empresa
     # 25.09.2017 - antes llamada set_estimated_value_global_currency
     # valor estimado de las acciones en compania en la moneda de las operaciones de la empresa. 

     self.estimated_value_operations_currency = estimated_value_now
     self.estimated_benefit_operations_currency = estimated_benefit_now
     self.perc_estimated_benefit_operations_currency = perc_estimated_benefit_now


     self.estimated_benefit_operations_currency_euros = estimated_benefit_euros_now
     self.perc_estimated_benefit_operations_currency_euros = perc_estimated_benefit_euros_now

   end

   def estimated_value_global_currency_now
     share_price_global_currency.to_f * shares_sum
   end

   def estimated_value_now # nueva
    # valor actual del total de acciones de la empresa en la moneda de COMPRA de la empresa    
    total = 0
    if self.currency_symbol_operations == Mycapital::CURRENCY_PURCHASE_SYMBOL.to_s then
      total = share_price_global_currency.to_f * shares_sum
    else      
      total = self.stock_price * shares_sum 

    end
    total
   end

 def estimated_benefit_euros_now  
    # calculamos el beneficio estimado en euros a partir de lo que nos costó en euros y lo que valdría ahora
    # si cambiáramos el valor estimado total a euros (sólo si tenemos acciones, claro)
    unless shares_sum == 0
      total = estimated_value_global_currency_now - puchased_sum_euros
      total.round(2)
    end
  end

  def perc_estimated_benefit_euros_now  # NUEVA
    # porcentaje de beneficio en base al valor estimado actual en la moneda de compra de la empresa
   
    total = 0
    unless invested_sum == 0 then
        total = estimated_benefit_euros_now.to_f * 100 / puchased_sum_euros.to_f
    end
    total.round(2)
  end


  def perc_estimated_benefit_now  # NUEVA
    # porcentaje de beneficio en base al valor estimado actual en la moneda de compra de la empresa
   
    total = 0
    unless invested_sum == 0 then
        total = estimated_benefit_now.to_f * 100 / invested_sum.to_f
    end
    total.round(2)
  end


   def estimated_benefit_now  # NUEVA Y REVISADA  
     # beneficio estimado tomando el precio actual en la moneda de compras de la empresa

    # si la empresa trabaja en la misma moneda que se compran las operaciones, no hay que convertir el precio de la acción a euros
    # Corresponde a las empresas españolas (euros) y a las extranjeras compradas con activotrade (si se compra en USD, el beneficio es en USD)
    if self.stockexchange_currency_symbol ==  self.currency_symbol_operations then
       total = estimated_value_now - invested_sum.to_f        
    else
       # la empresa es en moneda extranjera pero la compramos en euros (extranjera comprada en ING). Hay que convertir el 
       # valor total de las acciones de la empresa en moneda extranjera (USD, p.ej) hay que convertirlo a euros y 
       #  de ahí restarle el total invertido, que será en euros.
       total = estimated_value_global_currency_now - invested_sum.to_f    
    end
    total.round(2)
   end




  def set_average_price # AQUÍ TAMBIÉN HAY FOLLÓN
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

  def set_shares_sum     # REVISADO 
    # total de acciones
    self.shares_sum = (quantity_puchased.to_i - quantity_sold.to_i + quantity_ampliated.to_i).round(0)
    self.set_estimated_values()
  end

  def get_shares_sum_at_date(fecha)
    # devuelve el número de acciones que teníamos a la fecha recibida. Útil para calcular el dividendo previsto. 
    total = 0
    total = self.operations.where('(operationtype_id = ? or operationtype_id = ? ) and operation_date <= ?', Mycapital::OP_PURCHASE, Mycapital::OP_AMPLIATION, fecha).sum(:quantity)
    total = total - self.operations.where('operationtype_id = ?  and operation_date <= ?', Mycapital::OP_SALE, fecha).sum(:quantity)

    total
  end


  def set_invested_sum      # REVISADO 
    # total invertido actualmente, es decir, compras menos ventas en lamoneda de la aplicación (euros) + las ampliaciones, que también pueden costar dinero
    # hace cambiar el precio medio de la acción y el beneficio estimado
     self.invested_sum = puchased_sum.to_f - sold_sum.to_f + ampliated_sum.to_f
     self.set_average_price()
     self.set_estimated_values()
  end 


  def get_dividends
    # retorna el total de dividendos agrupados por moneda
    self.operations.where(:operationtype_id => Mycapital::OP_DIVIDEND).group(:currency_id).sum(:net_amount)
  end
  def set_dividend_sum         
    # sumamos los dividendos de las diferentes monedas, convirtiendo a euros los que no lo son
    # es decir, el campo pasa a guardarse siempre en euros
    total = 0 
    self.get_dividends.each do |key, value|                  
        total = total + convert_to_eur(value, Currency.find(key).name)                
    end 
    #total = self.operations.where(:operationtype_id => Mycapital::OP_DIVIDEND).sum(:net_amount)
    self.dividend_sum   = total.round(2)
  end

  def set_purchased_sum      # REVISADO 
    total = self.operations.where(:operationtype_id => Mycapital::OP_PURCHASE).sum(:amount)

    # comprado y ampliado para que guardar todo lo comprado. 
    puchased_sum_euros = self.operations.where(:operationtype_id => Mycapital::OP_PURCHASE).sum(:puchased_sum_euros) + self.operations.where(:operationtype_id => Mycapital::OP_AMPLIATION).sum(:puchased_sum_euros)

    self.puchased_sum = total.round(2)
    self.puchased_sum_euros = puchased_sum_euros.round(2)
    self.quantity_puchased = self.operations.where(:operationtype_id => Mycapital::OP_PURCHASE).sum(:quantity)

    # grabamos en la cabecera la moneda de una de las operaciones y esta servirá para compras, div, ventas...
    # también grabamos el broker para poder poner las monedas que correspondan al crear una nueva operación.
    # Se utilizará para mostrarla en el summary, donde la cantidad comprada, ampliada... así com el próximo dividendo
    res = self.operations.where(:operationtype_id => Mycapital::OP_PURCHASE).limit(1)        
    res.each do |p| 
       self.currency_symbol_operations = Currency.find(p.currency_operation_id).symbol
       self.broker_id = p.broker_id
    end
    

    self.set_shares_sum()
    self.set_invested_sum()
  end

  def set_sold_sum       # REVISADO 
      total = self.operations.where(:operationtype_id => Mycapital::OP_SALE).sum(:amount)
      self.sold_sum  = total.round(2)
      self.quantity_sold = self.operations.where(:operationtype_id => Mycapital::OP_SALE).sum(:quantity)
      self.set_shares_sum()
      self.set_invested_sum()
  end

  def set_ampliated_sum       # REVISADO 
      total = self.operations.where(:operationtype_id => Mycapital::OP_AMPLIATION).sum(:amount)
      self.ampliated_sum  = total.round(2)
      self.quantity_ampliated = self.operations.where(:operationtype_id => Mycapital::OP_AMPLIATION).sum(:quantity)
      self.set_shares_sum()
  end

  
  def set_average_price_origin_currency   # POR ACABAR (ANTES DE REVISIÓN 22.09.2017)
    # precio medio en la moneda de la empresa, es decir, independientemente de si he comprado en euros o no
      total = 0  # total sin comisiones
      total_real = 0      # total con comisiones
   
      
      self.operations.where.not(:operationtype_id => Mycapital::OP_DIVIDEND).each do |op| 
        unless op.origin_price.nil? || op.quantity.nil?
          exchange_to_origin_price = 0  
          unless op.exchange_rate ==0   
             # calculamos la tasa a aplicar para convertir de EUR a USD porque la que tenemos guardada es de USD a EUR
             exchange_to_origin_price = 1 / op.exchange_rate
          end

          if self.currency_symbol_operations.to_s == Mycapital::CURRENCY_PURCHASE_SYMBOL.to_s   then 
            # si la compra es en euros, hay que coger el precio origen y multiplicar por la tasa. 
             total_precio_origen = op.origin_price *  op.quantity
             total_precio_origen_venta =  op.amount *  exchange_to_origin_price    
          else
            # si no, basta con coger el precio de compra porque ya está en la moneda 'extranjera'
            total_precio_origen = op.price  *  op.quantity
            total_precio_origen_venta = op.amount
          end
        

          if op.operationtype_id == Mycapital::OP_SALE 
            # si es una venta tenemos que restarle el valor del importe
            total = total - total_precio_origen
            total_real = total_real - total_precio_origen_venta
          else
            total = total + total_precio_origen
            total_real = total_real + total_precio_origen_venta
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

  def set_update_summary ()  # REVISADO
    #operationtype_id
    # updateamos todas los campos del resumen: total invertido, dividendos, beneficios estimados...

    # case :operationtype_id
    # when Mycapital::OP_DIVIDEND then self.set_dividend_sum()
    # when Mycapital::OP_PURCHASE then self.set_purchased_sum()
    # when Mycapital::OP_SALE then  self.set_sold_sum()
    # when Mycapital::OP_AMPLIATION then  self.set_ampliated_sum()
    # end

    self.set_dividend_sum()   # 
    self.set_purchased_sum()   # OK
    self.set_sold_sum()       #
    self.set_ampliated_sum()  #


    self.set_average_price_origin_currency()  #

    
    #total.round(2)

  end

  def set_last_result_values      # REVISADO 
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
    # también la próxima fecha de declaración de dividendo.
    # primero borramos el valor que tenga
    self.next_dividend_date = nil
    self.next_dividend_amount = nil
  self.nearest_announce_date = nil

    res = self.company_historic_dividends.where('payment_date >= ?',Time.now.beginning_of_day).order(payment_date: :asc).limit(1)   
    res.each do |p| 
       self.next_dividend_date = p.payment_date
       self.next_dividend_amount = p.amount              
    end

    # si no hay fecha de próximo dividendo, buscamos la fecha más cercana en que se anunció el año pasado
    if self.next_dividend_date.nil?
      res = self.company_historic_dividends.where('announce_date <= ? and announce_date >= ?',Time.now.beginning_of_day - 12.month, Time.now.beginning_of_year - 12.month).order(announce_date: :desc).limit(1)
      res.each do |p| 
         self.nearest_announce_date = p.announce_date + 12.month
      end   
  end

    res = self.company_historic_dividends.where('exdividend_date >= ?',Time.now.beginning_of_day).order(exdividend_date: :asc).limit(1)             
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



  def get_stock_price    # REVISADO 
      # Recupera el precio, variación y % de variación de la acción de google finance (empresas españolas) o yahoo finance 
      # Graba los resultados en variables 
      begin
        #uri =URI.parse('http://finance.google.com/finance/info?q=' + self.google_symbol)
        @stock_price = 0
        @market_capitalization = 0
        @year_low = 0
        @year_high = 0
          
        @var_price =  0
        @var_percent= 0


        if Settings.yahoo_suffixes[self.stockexchange_id] != "dddd"  
          # si es el mercado continuo buscamos por google pq yahoo sólo tiene datos históricos

          uri =URI.parse('http://finance.google.com/finance?q=' + self.google_symbol + '&output=json')

          rs = Net::HTTP.get(uri)

          
          unless rs ==  "httpserver.cc: Response Code 400\n"
          
            rs.delete! '//'

            a = JSON.parse(rs) 

            @stock_price =  a[0]["l"] 
            @stock_price.sub!(',','')
            @stock_price = @stock_price.to_f
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
            @market_capitalization = stocks.market_capitalization
            @year_low = stocks.year_low
            @year_high = stocks.year_high
            @date_price = ""
            #unless stocks.last_trade_date.nil?
            #  @date_price= DateTime.strptime(stocks.last_trade_date, '%m/%d/%Y')
            #end            
             
          #end
        end   
        if self.stockexchange_currency_name == 'GBP' then
           @stock_price = @stock_price / 100
        end                

       rescue
          @date_price = ""
       end
       # si es UK la cotizacion viene en peniques. Dividimos por 100 para pasarla a libras.
        
       @stock_price
  end


  def stock_price    # REVISADO 
    # Valor actual de la acción recuperada de google o yahoo. 
    @stock_price.to_f
  end

  def var_price    # REVISADO 
     @var_price.to_f
  end

  def stock_price_formatted    # REVISADO 
    # Precio acción con formato. Se muestra, p.ej, en la mira.
    number_to_currency(@stock_price, unit:self.stockexchange_currency_symbol, seperator: ",", delimiter: ".")
  end

  def var_price_formatted     # REVISADO 
    number_to_currency(@var_price, unit:self.stockexchange_currency_symbol, seperator: ",", delimiter: ".")
  end  

  def var_percent     # REVISADO 
    @var_percent.to_f
  end

  def set_stock_price_google     # REVISADO 
    # graba el precio recuperado de google
    self.share_price =  get_stock_price          
    self.set_update_summary
            
  end

  def years_with_dividend     # REVISADO 
    ret = 0
    unless self.first_uninterrupted_year_div.nil? or self.first_uninterrupted_year_div == 0 
      ret = Date.today.year - self.first_uninterrupted_year_div
    end
    ret
  end


  def is_aristocrat     # REVISADO 
    self.years_with_dividend  > 25
  end

  def market_cap     # REVISADO 
    #self.shares_quantity * self.stock_price
    @market_capitalization
  end

 def year_low     # REVISADO 
    
    @year_low
  end

 def year_high     # REVISADO 
    
    @year_high
  end  
    


  def stockexchange_currency_symbol     # REVISADO 
   
     currency_symbol = "X"
    
      unless Settings.stockexchange_currency_symbol.nil?
         currency_symbol = Settings.stockexchange_currency_symbol[self.stockexchange_id]
      end

    currency_symbol
   
  end

  def stockexchange_currency_name     # REVISADO 
   
     currency_name = "Y"
    
      unless Settings.stockexchange_currency_name.nil?
         currency_name = Settings.stockexchange_currency_name[self.stockexchange_id]
      end

    currency_name
   
  end

 

  def number_currency_operations(value)  # NUEVA
     # formatea el valor en la moneda de las operaciones
    number_to_currency(value, unit:self.currency_symbol_operations.to_s, seperator: ",", delimiter: ".") 
  end


   def convert_to_eur(amount, currency_origin) 
      # share prices in currency purchases (ie, all the operations are bought in euros, 
      # the currency will be euros)
      unless currency_origin =="EUR"
     
        require 'money'
        require 'money/bank/google_currency'      
        bank = Money::Bank::GoogleCurrency.new
        #if currency_origin = 'p'
        # currency_origin = 'GBP'       
        #end
        
        begin ## ESTE BEGIN DEBERÍA IR AL PRINCIPIO, PARA CUANDO NO TENGO INTERNET
          amount = amount * bank.get_rate(currency_origin, Mycapital::CURRENCY_PURCHASE).to_f
          # la cotización de las acciones UK vienen en peniques y google currency  no tiene el tipo de cambio
          # por tanto, recuperamos la cotización en libras y dividimos por 100, que es lo mismo. 
       
        rescue  
          amount = 0
        end
        
      end
      
      unless amount.nil?
          amount.round(2)
      end
      
    end 
end