class CreateOrders < ActiveRecord::Migration[8.0]
  def change
    create_table :orders do |t|
      t.string :item_name
      t.integer :status
      t.references :user, null: false, foreign_key: true
      t.string :location
      t.timestamps
      validates :user_id, presence: true

    end
  end
end
