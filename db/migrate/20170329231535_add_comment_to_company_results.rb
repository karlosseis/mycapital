class AddCommentToCompanyResults < ActiveRecord::Migration
  def change
    add_column :company_results, :comment, :text
  end
end
