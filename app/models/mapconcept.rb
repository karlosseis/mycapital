class Mapconcept < ActiveRecord::Base
  belongs_to :subcategory
  belongs_to :user


  def self.search(search)

   if search 
    
      # if Rails.env.production?
      #  where('name ILIKE ?', "%#{search}%")
      # else
      #   where('name LIKE ?', "%#{search}%")
      # end
      where('lower(name) LIKE lower(?)', "%#{search}%")

    else

      scoped

    end

  end

  
end
