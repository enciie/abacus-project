class CreateExpenses < ActiveRecord::Migration
  def change
    create_table :expenses do |t|
      t.string :name
      t.decimal :price
      t.integer :user_id
      t.integer :group_id
      t.timestamps null: false
    end
  end
end
