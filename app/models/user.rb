class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  
  has_many :companies
  has_many :operations
  has_many :expected_dividends
  has_many :banks
  has_many :accounts
  has_many :balances
  has_many :balance_details
  has_many :expert_target_prices
  has_many :reference_webs
  has_many :company_comments
  has_many :company_results



  has_many :locations
  has_many :estimated_movements
  has_many :movementtypes
  has_many :planif_records
  has_many :periodicities
  has_many :subcategories
  has_many :categories  
  has_many :movements
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

	def to_s
		if self.last_name.nil?
			""
		else
			self.first_name
		end
	end

end
