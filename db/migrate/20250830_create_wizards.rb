class CreateWizards < ActiveRecord::Migration[7.0]
  def change
    create_table :wizards do |t|
      t.string :name, null: false
      t.string :email, null: false
      t.string :password, null: false
      t.date :date_of_birth, null: false
      t.text :bio
      t.boolean :muggle_relatives, null: false, default: false
      t.string :hogwarts_house, null: false
      t.boolean :is_admin, null: false, default: false

      t.timestamps
    end
    add_index :wizards, :email, unique: true
  end
end
