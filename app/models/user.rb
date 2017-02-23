class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  
  has_many :companies
  has_many :operations
  has_many :expected_dividends
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
end
