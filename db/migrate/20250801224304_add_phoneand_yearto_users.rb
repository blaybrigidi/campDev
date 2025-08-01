class AddPhoneandYeartoUsers < ActiveRecord::Migration[8.0]
  def change
    add_column: user, :phone_number, :string
    add_column:user, :year , :string
  end
end
