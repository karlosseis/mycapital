class ExpertTargetPrice < ActiveRecord::Base
  belongs_to :company
  belongs_to :user
  belongs_to :reference_web
end
