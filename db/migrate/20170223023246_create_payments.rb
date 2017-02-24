class CreatePayments < ActiveRecord::Migration[5.0]
  def change
    create_table :payments do |t|
      t.bigint :number
      t.integer :expiry_month
      t.integer :expiry_year
      t.integer :cvv
      t.timestamps
    end
  end
end
