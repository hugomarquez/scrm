class CreateCoreNotes < ActiveRecord::Migration[5.2]
  def change
    create_table :core_notes do |t|
      t.string      :slug,      unique: true
      t.boolean     :private
      t.string      :title
      t.text        :body
      t.belongs_to  :created_by
      t.references  :noteable, polymorphic: true, index: true
      t.timestamps
    end
  end
end
