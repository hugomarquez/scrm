class CreateCorePeople < ActiveRecord::Migration[5.2]
  def change
    create_table :core_people do |t|
      t.string      :slug,      unique: true
      t.string      :title
      t.string      :first_name
      t.string      :last_name
      t.string      :phone
      t.string      :home_phone
      t.string      :other_phone
      t.string      :email
      t.string      :assistant
      t.string      :asst_phone
      t.string      :extension
      t.string      :mobile
      t.date        :birthdate
      t.references  :personable, polymorphic: true, index: true
      t.timestamps
    end
  end
end
