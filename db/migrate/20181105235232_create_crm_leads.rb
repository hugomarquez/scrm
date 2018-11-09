class CreateCrmLeads < ActiveRecord::Migration[5.2]
  def change
    create_table :crm_leads do |t|
      t.string      :slug,      unique: true
      t.string      :number,    unique: true
      t.string      :source
      t.string      :company
      t.string      :industry
      t.string      :sic_code
      t.integer     :status
      t.string      :website
      t.integer     :rating
      t.text        :description
      t.belongs_to  :created_by
      t.timestamps
    end
  end
end
