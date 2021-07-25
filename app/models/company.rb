class Company < ActiveRecord::Base 
include ActionView::Helpers::NumberHelper
include ActionView::Helpers::DateHelper
require 'settings.rb'  


# 19/08/2018 - columnas dejadas de utilizar
# puchased_sum 
# invested_sum
# ampliated_sum
# sold_sum
# average_price_origin_currency 
# average_price_origin_currency_real



  #before_create :set_img_logo #, :set_stock_price_IEX ,:set_update_summary ,:retrieve_IEX_dividends_batch ,:set_next_official_dividend_values
  belongs_to :user
  belongs_to :stockexchange
  belongs_to :sector
  belongs_to :broker
  belongs_to :country
  
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
  
  @data_from_iex = false


  @iex_stats = nil
  @iex_quote = nil  


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



  def to_s  
    name
  end  

  def get_id
    id    
  end



  
  def perc_dividend_last_result   
    perc_expected = 0
    unless self.share_price==0 or self.share_price.nil? or self.dividend_last_result ==0 or self.dividend_last_result.nil?
      perc_expected = (self.dividend_last_result * 100) / self.share_price
    end
    perc_expected
  end

  def perc_estimated_year_dividend_amount
    perc_expected = 0
    unless self.share_price==0 or self.share_price.nil? or self.estimated_year_dividend_amount ==0 or self.estimated_year_dividend_amount.nil?
      perc_expected = (self.estimated_year_dividend_amount * 100) / self.share_price
    end
    perc_expected
  end

  def  date_share_price_time_ago
    date_price = ""
    unless self.date_share_price.nil? or self.date_share_price == ""
      date_price = "Hace " + time_ago_in_words(self.date_share_price)
    end

    date_price
  end

  def  date_share_price_formatted
    date_price = ""
    unless self.date_share_price.nil? or self.date_share_price == ""
      date_price = I18n.l(self.date_share_price)
    end

    date_price
  end

  def share_price_formatted  # REVISADO. NADA QUE REVISAR
    number_to_currency(self.share_price, unit:self.stockexchange_currency_symbol, seperator: ",", delimiter: ".")
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

  def url_morningstar_ratios    
    "http://financials.morningstar.com/ratios/r.html?t=" + self.symbol
  end

  def url_morningstar_incomes
    "http://financials.morningstar.com/income-statement/is.html?t=" + self.symbol
  end

  def url_IEX
    "https://iextrading.com/apps/stocks/" + self.symbol
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
    self.share_price - self.target_price_1
  end

  def dif_target_sell_price 
    ret = 99999
    unless self.target_sell_price.nil?
      ret = self.share_price - self.target_sell_price
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
      perc_result = (self.dif_target_sell_price * 100) / self.share_price
    end
    perc_result    * -1
  end

  def porc_dif_target_price    
    perc_result = 0 
    unless self.dif_target_price<=0
      perc_result = (self.dif_target_price * 100) / self.share_price
    end
    perc_result    
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
      total = self.share_price * shares_sum 

    end
    total
   end

 def estimated_benefit_euros_now  
    # calculamos el beneficio estimado en euros a partir de lo que nos costó en euros y lo que valdría ahora
    # si cambiáramos el valor estimado total a euros (sólo si tenemos acciones, claro)
    unless shares_sum == 0
      total = estimated_value_global_currency_now - invested_sum_euros
      total.round(2)
    end
  end

  def perc_estimated_benefit_euros_now  # NUEVA
    # porcentaje de beneficio en base al valor estimado actual en la moneda de compra de la empresa
   
    total = 0
    unless invested_sum == 0 then
        total = estimated_benefit_euros_now.to_f * 100 / invested_sum_euros.to_f
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





  def get_shares_sum_at_date(fecha)
    # devuelve el número de acciones que teníamos a la fecha recibida. Útil para calcular el dividendo previsto. 

    total = 0
    
    #logger.debug "Company " + self.name
    
   

    total = self.operations.where('(operationtype_id = ? or operationtype_id = ? ) and operation_date <= ?', Mycapital::OP_PURCHASE, Mycapital::OP_AMPLIATION, fecha).sum(:quantity)
    #logger.info "Total 1: %s " % total
    total = total - self.operations.where('operationtype_id = ?  and operation_date <= ?', Mycapital::OP_SALE, fecha).sum(:quantity)
    #logger.info "Total 2: %s " % total
   
    total
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
        total = total + (value * Settings.convert_currency(Currency.find(key).name, Mycapital::CURRENCY_PURCHASE))

    end 
    #total = self.operations.where(:operationtype_id => Mycapital::OP_DIVIDEND).sum(:net_amount)
    self.dividend_sum   = total.round(2)
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


  def set_invested_sum      # REVISADO 
    # total invertido actualmente, es decir, compras menos ventas en lamoneda de la aplicación (euros) + las ampliaciones, que también pueden costar dinero
    # hace cambiar el precio medio de la acción y el beneficio estimado


    arr = []   # array con las compras y ampliaciones de las acciones que tenemos acutalmente. Es decir, aquellas que no hemos vendido. 

    hay_venta = 0
    total_benefit = 0 # ganancias o pérdidas de las operaciones de compraventa  
    total_benefit_euros = 0 # ganancias o pérdidas de las operaciones de compraventa  


    temp_total_benefit = 0
    # deb = []
    
    res = self.operations.where('operationtype_id = ? or operationtype_id = ? or operationtype_id = ?', Mycapital::OP_PURCHASE, Mycapital::OP_AMPLIATION, Mycapital::OP_SALE).order(operation_date: :asc).all
    res.each do |p| 
           if p.operationtype_id != Mycapital::OP_SALE
              # Si es una compra o ampliación, la guardamos en la matriz
              arr.push  [ p.quantity, p.puchased_sum_euros /  p.quantity, p.amount /  p.quantity , p.price]
                        # cantidad, precio unidad segun el total comprado en euros, precio unidad en moneda de la compra, precio de la accion (sin tasas) , precio de la accion sin tasas en euros

              temp_total_benefit = temp_total_benefit - p.amount
           else 
              # Si es una venta, borramos la o las compras que hemos vendido (las que van antes cronológicamente)
             quant_pend =  p.quantity
             items_a_borrar = 0 
             arr.each  do |a| 

                #deb.push "antes if  a[0]: " + a[0].to_s + "   quant_pend: "  + quant_pend.to_s
                if a[0] <= quant_pend       # si con la compra no hay suficiente para igualar la cantidad de venta, lo borramos porque significa que 'se ha vendido'
                  quant_pend =  quant_pend - a[0]
                                    
                  items_a_borrar = items_a_borrar + 1
                else
                   # Sino, es que hasta aquí se ha vendido. 
                   # deb.push "entra en break, a[0]:" + a[0].to_s  + "   quant_pend:  " + quant_pend.to_s + "   resultado a[0]  - quant_pend :" + (a[0]  - quant_pend).to_s
                   a[0] =  a[0]  - quant_pend                                     
                   break
                end
               
             end
             hay_venta = 1  # marcamos que hay una venta para que tenga sentido un total de beneficios (si no hay venta, todo son compras y no puede haber ganancia o pérdida)
             total_benefit = temp_total_benefit + p.amount
             temp_total_benefit = 0

             # 19.08.2018 - Aquí quería guardar el beneficio o pérdida de la venta, pero se cuelga.
             # p.earnings_sum = total_benefit
             # p.save

             arr = arr.drop(items_a_borrar)

           end              
    end    

    #deb.push arr

    self.shares_sum = 0
    self.invested_sum_euros= 0    
    self.invested_sum = 0
    temp_average_price = 0


    self.average_price = 0
    self.average_price_real = 0

    arr.each  do |a| 

          self.shares_sum =  self.shares_sum +  a[0]
          
          self.invested_sum_euros =  self.invested_sum_euros +  (a[0] *  a[1])  # Total en euros
          

          self.invested_sum =  self.invested_sum +  (a[0] *  a[2])   # Total en moneda de compra


          temp_average_price = temp_average_price + (a[0] *  a[3])

     end

    unless shares_sum == 0
      
      self.average_price = (temp_average_price / self.shares_sum).round(2)
      self.average_price_real = (self.invested_sum / self.shares_sum).round(2)


    end 
    
    if hay_venta == 1
      self.earnings_sum = total_benefit
      self.earnings_sum_euros = 0
    else
      self.earnings_sum = 0
      self.earnings_sum_euros = 0 
    end


    # grabamos en la cabecera la moneda de una de las operaciones y esta servirá para compras, div, ventas...
    # también grabamos el broker para poder poner las monedas que correspondan al crear una nueva operación.
    # Se utilizará para mostrarla en el summary, donde la cantidad comprada, ampliada... así com el próximo dividendo
    res = self.operations.where(:operationtype_id => Mycapital::OP_PURCHASE).limit(1)        
    res.each do |p| 
       self.currency_symbol_operations = Currency.find(p.currency_operation_id).symbol
       self.broker_id = p.broker_id
    end



    self.set_estimated_values()


    #deb
  end 


  
    

  def set_update_summary ()  # REVISADO

    self.set_dividend_sum()   # 
    self.set_invested_sum()   # OK
    

    
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
    self.next_exdividend_date = nil
    res = self.company_historic_dividends.where('payment_date >= ?',Time.now.beginning_of_day).order(payment_date: :asc).limit(1)   
    res.each do |p| 
       self.next_dividend_date = p.payment_date
       self.next_dividend_amount = p.amount              
    end

    # Buscamos si ya se debería haber anunciado el siguiente dividendo y no lo tenemos puesto
    # la idea es buscar si el año pasado se anunció el dividendo por estas fechas (hasta un mes antes)
  
      # Buscamos los dividendos del AÑO ACTUAL para saber de cuantos tenemos fecha de pago prevista
      div = self.company_historic_dividends.where('payment_date >= ? and payment_date <= ?', Time.now.beginning_of_year, Time.now.end_of_year).order(payment_date: :asc)   
      num_divs_current_year = div.count
      if num_divs_current_year == self.dividend_payments_quantity
         # si ya hemos puesto todos los dividendos que se cobran este año (según están establecidos a nivel de empresa)
         # tenemos que buscar si el primero si el primero del año siguiente ya tocaría anunciarlo en estas fechas.
         # P.ej, red electrica paga el último en julio y anuncia el primero del año siguiente en noviembre
         # Si estamos en agosto no debería salir, pero si estamos en diciembre, sí. 

         sig_div  = div.first
      

      else
       # buscamos los divendos del AÑO PASADO
       div = self.company_historic_dividends.where('payment_date >= ? and payment_date <= ?', Time.now.beginning_of_year - 1.year, Time.now.end_of_year - 1.year).order(payment_date: :asc)   
       cont = 1        
       # de todos los dividendos del año pasado, tenemos que coger el siguiente que toca. 
       # es decir, si tenemos 3 dividendos puestos este año, del año pasado tendríamos que coger el número 4
       div.each do |p|     
            
            if cont ==  num_divs_current_year + 1
              sig_div = p
            end
         
       end      
      end
      unless sig_div.nil?
        if sig_div.announce_date + 1.year   >=   (Time.now).beginning_of_day  - 30.day  
          self.nearest_announce_date = sig_div.announce_date + 1.year
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

  def stats(field)
    if self.IEX_avaliable 
      # significa que podemos recuperar la data de IEX 

      if @iex_stats.nil?
        # si es la primera vez que entramos, la cargamos.
        iex = Iex.new(self.yahoo_symbol)
        @iex_stats = iex.stats
      end 


      @iex_stats[field]
  
      
    else
      0
    end
    
  end

  def quote(field)


    if self.IEX_avaliable
      # significa que podemos recuperar la data de IEX 

      if @iex_quote.nil?
        # si es la primera vez que entramos, la cargamos.
        iex = Iex.new(self.yahoo_symbol)
        @iex_quote = iex.quote
      end 


      @iex_quote[field]
  
      
    else
      0
    end    
  end

  def img_logo
    if self.IEX_avaliable
      iex = Iex.new(self.yahoo_symbol)
      iex.image_logo    
    end
  end


  def set_img_logo
    if self.IEX_avaliable and self.logo_url = ''
        self.logo_url = self.img_logo 
    end
  end


  def dividends(range)
    if self.IEX_avaliable
      iex = Iex.new(self.yahoo_symbol)
      iex.dividends(range)
    end
  end

  def dividends_batch()
    if self.IEX_avaliable
      iex = Iex.new(self.yahoo_symbol)
      iex.dividends_batch()
    end
  end
  

  def news
    if self.IEX_avaliable
      iex = Iex.new(self.yahoo_symbol)
      iex.news
    end
  end


  def get_news
    
    news = self.news
    unless news.nil?
      
      news.each do |p|         
        p["headline"]
        p["url"]
        p["summary"]        
        p["image"]
        p["datetime"]
      end
    end  
  end




  def IEX_avaliable  
    # Si es el mercado americano (en yahoo no tiene sufijo), podremos recuperar la data de IEX
    Settings.yahoo_suffixes[self.stockexchange_id] == ""
  end

  def set_stock_price_IEX    
    # graba el precio recuperado de IEX 
    # 06.03.2019 - solo si el mercado está abierto, para minimizar las llamadas a la api

    if self.IEX_avaliable
      if self.stockexchange.open_time.hour <= Time.now.hour and self.stockexchange.close_time.hour >= Time.now.hour


        iex = Iex.new(self.yahoo_symbol)
        quote = iex.quote
        #@iex_stats = iex.stats
        
      
        self.share_price =   quote['latestPrice'].to_f
        self.share_price_change =  quote['change'].to_f
        self.share_price_change_perc = quote['changePercent'].to_f * 100
        self.date_share_price = Time.now
      end
    end
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


  def retrieve_IEX_dividends
    # recuperamos los dividendos de IEX y los grabamos físicamente como histórico de dividendos
    if self.IEX_avaliable 
      div = self.dividends('5y')
      div.each do |p| 
        if self.company_historic_dividends.where('payment_date = ?', p["paymentDate"]).count == 0
          histdiv = self.company_historic_dividends.new(            
            exdividend_date: p["exDate"],
            record_date: p["recordDate"],
            announce_date: p["declaredDate"],
            dividend_type: 0,
            payment_date: p["paymentDate"],
            amount: p["amount"],      
            retrieved_auto: true,
            user_id: self.user_id)   

          histdiv.save
        end

      end
    end  
  end

  def country_flag_icon    

    case self.country.name

      when 'España' 
      return 'flag-icon-es'
      when 'USA'
        return 'flag-icon-us'
      when 'Holanda'
        return 'flag-icon-aw'
      when 'Gran Bretaña'
        return 'flag-icon-gb'
      when 'Alemania'
        return 'flag-icon-de'
      when 'Francia'
        return 'flag-icon-fromCharCode'
      when 'Noruega'
        return 'flag-icon-no'
      when 'Canadá'
        return 'flag-icon-ca'



        else
          return ''
        end



  end

  def retrieve_IEX_dividends_batch
    # recuperamos los dividendos de IEX y los grabamos físicamente como histórico de dividendos
    # 13/03/2020 - usando el servico batch, porque el otro ha dejado de ir bien

    # [{"exDate":"2015-05-18","paymentDate":"2015-06-10","recordDate":"2015-05-20","declaredDate":"2015-03-11","amount":"0.520000000","flag":"Cash","currency":"USD","description":"Ordinary Shares","frequency":"quarterly","date":"2020-03-13"}]
    # {"TGT":{"dividends":[{"exDate":"2020-02-18","paymentDate":"2020-03-10","recordDate":"2020-02-19","declaredDate":"2020-01-08","amount":"0.66","flag":"Cash","currency":"USD","description":"Ordinary Shares","frequency":"quarterly","date":"2020-03-13"}]}}
    if self.IEX_avaliable 
      div_completo = self.dividends_batch()
      unless div_completo.nil?
        div = div_completo[self.symbol]["dividends"]
        div.each do |p| 
          if self.company_historic_dividends.where('payment_date = ?', p["paymentDate"]).count == 0
            histdiv = self.company_historic_dividends.new(            
              exdividend_date: p["exDate"],
              record_date: p["recordDate"],
              announce_date: p["declaredDate"],
              dividend_type: 0,
              payment_date: p["paymentDate"],
              amount: p["amount"],      
              retrieved_auto: true,
              user_id: self.user_id)   

            histdiv.save
          end

        end
      end
    end  
  end

end