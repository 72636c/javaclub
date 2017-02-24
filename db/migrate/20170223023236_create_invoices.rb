class CreateInvoices < ActiveRecord::Migration[5.0]
  def change
    create_table :invoices do |t|
      t.references :order
      t.references :payment
    end
  end
end
