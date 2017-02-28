class CreateInvoices < ActiveRecord::Migration[5.0]
  def change
    create_table :invoices do |t|
      t.string :uuid, :limit => 36
      t.references :order
      t.references :payment
    end
  end
end
