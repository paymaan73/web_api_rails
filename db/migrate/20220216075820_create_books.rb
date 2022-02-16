class CreateBooks < ActiveRecord::Migration[7.0]
  def change
    create_table :books do |t|
      t.string :title, index: true
      t.text :subtitle
      t.string :isbn_10, index: true
      t.string :isbn_13, index: true
      t.text :description
      t.date :released_on
      t.references :publisher, null: false, foreign_key: true, index: true
      t.references :author, null: false, foreign_key: true, index: true

      t.timestamps
    end
  end
end
