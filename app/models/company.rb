class Company < ActiveRecord::Base
include ActionView::Helpers::NumberHelper
include ActionView::Helpers::DateHelper
  belongs_to :user
  belongs_to :stockexchange
  belongs_to :sector
  
  has_many :operations, dependent: :destroy
  has_many :expected_dividends



  validates :name, presence: true
  validates :symbol, presence: true
  validates :stockexchange, presence: true
  #validates :sector, presence: true
  validates :search_symbol, presence: true
  

  accepts_nested_attributes_for :operations,reject_if: proc { |attributes| attributes['amount'].blank? }

  def to_s
    name
  end  

  def get_id
    id
    
  end


  def  date_share_price_time_ago
    date_price = ""
    unless date_share_price.nil?
      date_price = "Hace " + time_ago_in_words(date_share_price)
    end

    date_price
  end

  def  date_share_price_formatted
    date_price = ""
    unless date_share_price.nil?
      date_price = I18n.l(date_share_price)
    end

    date_price
  end

  def share_price_formatted
    number_to_currency(self.share_price, unit:self.stockexchange.currency.symbol, seperator: ",", delimiter: ".")
  end

  def url_google_finance
    if self.stockexchange.currency.name ==  Mycapital::CURRENCY_PURCHASE then
      prefix = "BME:"
    else
      prefix = ""
    end
    "https://www.google.com/finance?q=" + prefix + self.symbol
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
    div = self.expected_dividends.order(operation_date: :asc).limit(1)   
    amount = ""
    date_dividend = ""

      div.each do |p| 
          amount = number_to_currency(p.amount)
          date_dividend = I18n.l(p.operation_date)
      end
      ret = { a: amount, b: date_dividend}   
     
      ret


  end

  def share_price_global_currency 
    # share prices in currency purchases (ie, all the operations are bought in euros, 
    # the currency will be euros)
    total = 0
    if self.stockexchange.currency.name ==  Mycapital::CURRENCY_PURCHASE then
       total = self.share_price
    else
      require 'money'
      require 'money/bank/google_currency'      
      bank = Money::Bank::GoogleCurrency.new
      
      begin
        total = self.share_price * bank.get_rate(self.stockexchange.currency.name, Mycapital::CURRENCY_PURCHASE).to_f
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
      self.operations.where.not(:operationtype_id => Mycapital::OP_DIVIDEND).each do |op| 
        unless op.price.nil? || op.quantity.nil?

          if op.operationtype_id == Mycapital::OP_SALE 
            # si es una venta tenemos que restarle el valor del importe
            total = total - (op.price *  op.quantity)
          else
            total = total + (op.price *  op.quantity)
          end
        end
        
      end    
      unless self.shares_sum == 0 
        total = total / self.shares_sum   
      end 
      self.average_price = total.round(2)

      # (# compra 1 * precio 1) + (# compra 2*precio 2) + (# venta 1*precio1) + (# ampliacion 1*precio1)/ (#compra1 + #compra2 + # venta 1 +  # ampliacion 1)
      # hay que tener en cuenta las ventas y también las ampliaciones
  end

  def set_shares_sum
    # total de acciones
    self.shares_sum = (quantity_puchased.to_i - quantity_sold.to_i + quantity_ampliated.to_i).round(0)
    self.set_estimated_value_global_currency()
  end


  def set_invested_sum 
    # total invertido actualmente, es decir, compras menos ventas en lamoneda de la aplicación (euros)
    # hace cambiar el precio medio de la acción y el beneficio estimado
     self.invested_sum = puchased_sum.to_f - sold_sum.to_f
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
      self.operations.where.not(:operationtype_id => Mycapital::OP_DIVIDEND).each do |op| 
        unless op.origin_price.nil? || op.quantity.nil?

          if op.operationtype_id == Mycapital::OP_SALE 
            # si es una venta tenemos que restarle el valor del importe
            total = total - (op.origin_price *  op.quantity)
          else
            total = total + (op.origin_price *  op.quantity)
          end
        end
        
      end    
      unless self.shares_sum == 0 
        total = total / self.shares_sum   
      end 
      self.average_price_origin_currency = total.round(2)

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


end