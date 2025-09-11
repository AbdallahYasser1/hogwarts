class CreateWizardFollows < ActiveRecord::Migration[8.0]
  def change
    create_table :wizard_follows do |t|
      t.references :follower, null: false, foreign_key: { to_table: :wizards }
      t.references :followed, null: false, foreign_key: { to_table: :wizards }
      t.timestamps
    end
    add_index :wizard_follows, [ :follower_id, :followed_id ], unique: true
  end
end
