class CreateCoreTasks < ActiveRecord::Migration[5.2]
  def change
    create_table :core_tasks do |t|
      t.string      :slug,      unique: true
      t.belongs_to  :assigned_to
      t.references  :taskable, polymorphic: true, index: true
      t.string      :subject
      t.text        :description
      t.string      :location
      t.string      :color
      t.boolean     :all_day
      t.datetime    :starts_at
      t.datetime    :ends_at
      t.integer     :status
      t.integer     :priority
      t.timestamps
    end
  end
end
