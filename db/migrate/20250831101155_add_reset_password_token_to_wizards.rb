class AddResetPasswordTokenToWizards < ActiveRecord::Migration[7.0]
  def change
    add_column :wizards, :reset_password_token, :string
    add_column :wizards, :reset_password_sent_at, :datetime
    add_index :wizards, :reset_password_token, unique: true
  end
end
