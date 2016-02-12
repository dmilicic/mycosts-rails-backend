class CreateCosts < ActiveRecord::Migration
  def change
    create_table :costs do |t|
      t.string :category
      t.string :description
      t.date :date
      t.float :amount
      t.string :currency

      t.timestamps null: false
    end
  end
end
