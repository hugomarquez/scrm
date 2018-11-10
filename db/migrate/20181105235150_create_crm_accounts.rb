class CreateCrmAccounts < ActiveRecord::Migration[5.2]
  def change
    create_table :crm_accounts do |t|
      t.string      :slug,      unique: true
      t.string      :number,    unique: true
      t.string      :name
      t.string      :phone
      t.string      :extension
      t.string      :email
      t.string      :website
      t.string      :industry
      t.float       :annual_revenue
      t.integer     :rating
      t.integer     :ownership
      t.integer     :priority
      t.integer     :employees
      t.integer     :locations
      t.string      :sic_code
      t.boolean     :active
      t.string      :ticker_symbol
      t.text        :description
      t.belongs_to  :created_by
      t.timestamps
    end
  end
end
