class YahooTicker < ActiveRecord::Base
	def self.search(search)
	  #where("name LIKE ?", "%#{search}%") 
	  #where("name LIKE ?", search["search"]) 
	  #where("name LIKE %#{" + search["search"] + "}%") 
	  buscar = search["search"].to_s
	  where("name LIKE ?", "%" + buscar + "%") 
	end
end
