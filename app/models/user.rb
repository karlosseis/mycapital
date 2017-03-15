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
