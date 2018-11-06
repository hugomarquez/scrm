class CreateCrmContacts < ActiveRecord::Migration[5.2]
  def change
    create_table :crm_contacts do |t|
      t.string      :slug,      unique: true
      t.integer     :lead_source
      t.integer     :level
      t.string      :language
      t.text        :description
      t.belongs_to  :account
      t.belongs_to  :created_by
      t.timestamps
    end
  end
end
