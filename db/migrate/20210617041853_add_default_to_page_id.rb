class AddDefaultToPageId < ActiveRecord::Migration[6.1]
  def change
    change_column_default(:pages, :page_id, nil)
  end
end
