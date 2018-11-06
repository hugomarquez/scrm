class CreateCoreUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :core_users do |t|
      t.string      :slug,      unique: true
      t.belongs_to  :organization
      t.belongs_to  :role
      t.string      :username
      t.string      :company
      t.string      :department
      t.string      :division
      t.time        :start_of_day
      t.time        :end_of_day

      ## Database authenticatable
      t.string :email,              null: false, default: ""
      t.string :encrypted_password, null: false, default: ""

      ## Token Authenticable
      t.string :authentication_token, null: false, default:""

      ## Recoverable
      t.string   :reset_password_token
      t.datetime :reset_password_sent_at

      ## Rememberable
      t.datetime :remember_created_at

      ## Trackable
      t.integer  :sign_in_count, default: 0, null: false
      t.datetime :current_sign_in_at
      t.datetime :last_sign_in_at
      t.string     :current_sign_in_ip
      t.string     :last_sign_in_ip

      ## Confirmable
      t.string   :confirmation_token
      t.datetime :confirmed_at
      t.datetime :confirmation_sent_at
      t.string   :unconfirmed_email # Only if using reconfirmable

      ## Lockable
      # t.integer  :failed_attempts, default: 0, null: false # Only if lock strategy is :failed_attempts
      # t.string   :unlock_token # Only if unlock strategy is :email or :both
      # t.datetime :locked_at
      t.timestamps
    end
    add_index :core_users, :email,                unique: true
    add_index :core_users, :reset_password_token, unique: true
    add_index :core_users, :confirmation_token,   unique: true
    # add_index :core_users, :unlock_token,         unique: true
  end
end
