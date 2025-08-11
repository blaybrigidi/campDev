class AddServiceProviderToOrders < ActiveRecord::Migration[8.0]
  def change
    add_column :orders, :service_provider_id, :integer
  end
end
