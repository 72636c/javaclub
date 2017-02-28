class CreatePayments < ActiveRecord::Migration[5.0]
  def change
    create_table :payments do |t|
      t.string :number, :limit => 19
      t.date :expiry
      t.string :cvv, :limit => 4
      t.timestamps
    end
  end
end
