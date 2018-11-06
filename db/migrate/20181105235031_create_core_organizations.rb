class CreateCoreOrganizations < ActiveRecord::Migration[5.2]
  def change
    create_table :core_organizations do |t|
      t.string      :slug,      unique: true
      t.string      :name
      t.string      :phone
      t.belongs_to  :owner
      t.timestamps
    end
  end
end
