class AddRememberDigestToWizards < ActiveRecord::Migration[7.0]
  def change
    add_column :wizards, :remember_digest, :string
  end
end
