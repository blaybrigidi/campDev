class CreateMessages < ActiveRecord::Migration[8.0]
  def change
    create_table :messages do |t|
      t.references :order, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.text :text, null: false

      t.timestamps
    end
    
    add_index :messages, [:order_id, :created_at]
  end
end
