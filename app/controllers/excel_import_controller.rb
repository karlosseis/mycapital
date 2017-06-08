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


end
