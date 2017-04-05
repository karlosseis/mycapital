class AddDateCommentToComments < ActiveRecord::Migration
  def change
    add_column :company_comments, :date_comment, :date
  end
end
