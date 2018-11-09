class CreateCrmDeals < ActiveRecord::Migration[5.2]
  def change
    create_table :crm_deals do |t|
      t.string      :slug,      unique: true
      t.string      :number,    unique: true
      t.boolean     :private
      t.string      :name
      t.integer     :category
      t.integer     :lead_source
      t.string      :tracking_number
      t.text        :description
      t.float       :amount
      t.float       :expected_revenue
      t.date        :close_at
      t.string      :next_step
      t.integer     :probability
      t.integer     :stage
      t.string      :main_competitor
      t.string      :delivery_status
      t.belongs_to  :account
      t.belongs_to  :created_by
      t.timestamps
    end
  end
end
