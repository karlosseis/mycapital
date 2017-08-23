class ExcelImportController < ApplicationController

  def index
  end

def import_historic_dividend
 
  #comp = Company.where("email = ?", "abc@xyz.com").first
  spreadsheet = Roo::Spreadsheet.open(params[:file].path)
  header = spreadsheet.row(1)
  (2..spreadsheet.last_row).each do |i|
    row = Hash[[header, spreadsheet.row(i)].transpose]   
    comp = current_user.companies.where('symbol = ? ', row["ticker"]).first   
    if comp
	    hist = comp.company_historic_dividends.new
	    #hist.attributes = row.to_hash #.slice(:exdividend_date, :record_date, :announce_date, :payment_date, :amount, :dividend_type)
	    hist.user_id = comp.user_id
	    hist.exdividend_date = row["exdividend_date"]
	    hist.record_date = row["record_date"]
	    hist.announce_date = row["announce_date"]
	    hist.payment_date = row["payment_date"]
	    hist.amount = row["amount"]
	    hist.dividend_type = row["dividend_type"]
	    hist.save!
	end
  end
  redirect_to root_url, notice: 'Products imported.'
end

def import_categories
  
  spreadsheet = Roo::Spreadsheet.open(params[:file].path)
  header = spreadsheet.row(1)
  (2..spreadsheet.last_row).each do |i|
	row = Hash[[header, spreadsheet.row(i)].transpose]   

	    entity = Category.new
		#entity = comp.company_historic_dividends.new
	    #entity.attributes = row.to_hash #.slice(:exdividend_date, :record_date, :announce_date, :payment_date, :amount, :dividend_type)
	    entity.user_id = current_user.id
	    entity.name = row["name"]	  
	    entity.save!
	end
  
  redirect_to root_url, notice: 'Categorías importadas.'	
end


def import_subcategories
 
  #categ = categany.where("email = ?", "abc@xyz.com").first
  spreadsheet = Roo::Spreadsheet.open(params[:file].path)
  header = spreadsheet.row(1)
  (2..spreadsheet.last_row).each do |i|
    row = Hash[[header, spreadsheet.row(i)].transpose]   
    categ = current_user.categories.where('name = ? ', row["category_name"]).first   
    if categ
	    entity = categ.subcategories.new
	    entity.user_id = current_user.id
	    entity.name = row["name"]	  
	    entity.save!
	end
  end
  redirect_to root_url, notice: 'Subcategorías importada.'
end


def import_locations
  
  spreadsheet = Roo::Spreadsheet.open(params[:file].path)
  header = spreadsheet.row(1)
  (2..spreadsheet.last_row).each do |i|
	row = Hash[[header, spreadsheet.row(i)].transpose]   

	    entity = Location.new
		#entity = comp.company_historic_dividends.new
	    #entity.attributes = row.to_hash #.slice(:exdividend_date, :record_date, :announce_date, :payment_date, :amount, :dividend_type)
	    entity.user_id = current_user.id
	    entity.name = row["name"]
	    entity.name_long = row["name_long"]	  		  
	    entity.save!
	end
  
  redirect_to root_url, notice: 'ubicaciones importadas.'	
end



def import_mapconcepts
 
  #categ = categany.where("email = ?", "abc@xyz.com").first
  spreadsheet = Roo::Spreadsheet.open(params[:file].path)
  header = spreadsheet.row(1)
  (2..spreadsheet.last_row).each do |i|
    row = Hash[[header, spreadsheet.row(i)].transpose]   
	    entity = Mapconcept.new
	    subcateg = current_user.subcategories.where('name = ? ', row["subcategoria"]).first   
	    if subcateg
	    	entity.subcategory_id = subcateg.id
	    end	 
	    entity.user_id = current_user.id
	    entity.name = row["name"]	  
	    entity.save!
  end
  redirect_to root_url, notice: 'mapeo conceptos y subcategorías importadas.'
end

def import_planif_records
  
  spreadsheet = Roo::Spreadsheet.open(params[:file].path)
  header = spreadsheet.row(1)
  (2..spreadsheet.last_row).each do |i|
	row = Hash[[header, spreadsheet.row(i)].transpose]   

	    entity = PlanifRecord.new
		#entity = comp.company_historic_dividends.new
	    #entity.attributes = row.to_hash #.slice(:exdividend_date, :record_date, :announce_date, :payment_date, :amount, :dividend_type)
	    entity.user_id = current_user.id
	    entity.name = row["concepto"]	
	    entity.amount = row["importe_estimado"]
	    entity.day = row["dia_estimado"]  
	    entity.start_month = row["mes_inicio"]
	    entity.start_at = row["start_at"]
	    #entity.end_at = row["end_at"]

	    subcateg = current_user.subcategories.where('name = ? ', row["subcategoria"]).first   
	    if subcateg
	    	entity.subcategory_id = subcateg.id
	    end	    
	    
	    cuenta = current_user.accounts.where('name = ? ', row["cuenta"]).first   
	    if cuenta
	    	entity.account_id = cuenta.id
	    end	  

	    period = current_user.periodicities.where('name = ? ', row["tipo"]).first   
	    if period
	    	entity.periodicity_id = period.id
	    end	  	    	    
  
	    entity.save!
	end
  
  redirect_to root_url, notice: 'planificación registros importados.'	
end


def import_movements
  
  spreadsheet = Roo::Spreadsheet.open(params[:file].path)
  header = spreadsheet.row(1)
  (2..spreadsheet.last_row).each do |i|
	row = Hash[[header, spreadsheet.row(i)].transpose]   

	    entity = Movement.new
		#entity = comp.company_historic_dividends.new
	    #entity.attributes = row.to_hash #.slice(:exdividend_date, :record_date, :announce_date, :payment_date, :amount, :dividend_type)
	    entity.user_id = current_user.id
	    entity.name = row["concepto"]	
	    entity.amount = row["importe"]
	    entity.movement_date = row["fecha"]
                    
        # si la subcategoria no viene informada buscamos la que le corespondería según el concepto
	    if row["subcategoria"].nil? or row["subcategoria"] == "" then	    	
	    	map  = current_user.mapconcepts.search(row["concepto"]	)
	    	unless map.count == 0
				entity.subcategory_id = map[0].subcategory_id
	    	end
	    else # sino le asignamos la que tiene
		    subcateg = current_user.subcategories.where('name = ? ', row["subcategoria"]).first   
		    if subcateg
		    	entity.subcategory_id = subcateg.id
		    end	    	    	
	    end

	    movementtype = current_user.movementtypes.where('name = ? ', row["tipo"]).first   
	    if movementtype
	    	entity.smovementtype_id = movementtype.id
	    end	 


	    
	    location = current_user.locations.where('name = ? ', row["ubicacion"]).first   
	    if location
	    	entity.location_id = location.id
	    end	  	    	    
  
  	    cuenta = current_user.accounts.where('name = ? ', row["cuenta"]).first   
	    if cuenta
	    	entity.account_id = cuenta.id
	    end	  
	    entity.save!
	end
  
  redirect_to root_url, notice: 'movimientos importados.'	
end

end
