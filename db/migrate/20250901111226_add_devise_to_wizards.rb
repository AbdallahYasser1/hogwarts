# frozen_string_literal: true

class AddDeviseToWizards < ActiveRecord::Migration[8.0]
  def change
    rename_column :wizards, :password_digest, :encrypted_password
    add_column :wizards, :remember_created_at, :datetime
  end
end
