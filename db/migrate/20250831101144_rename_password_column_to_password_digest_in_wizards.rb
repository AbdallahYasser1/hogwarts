class RenamePasswordColumnToPasswordDigestInWizards < ActiveRecord::Migration[8.0]
  def change
    rename_column :wizards, :password, :password_digest
  end
end
