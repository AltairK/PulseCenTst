class CreatePages < ActiveRecord::Migration[6.1]
  def change
    create_table :pages do |t|
      t.string :name
      t.string :title
      t.text :text
      t.references :page

      t.timestamps
    end
    add_index :pages, %i[page_id name], unique: true
  end
end
