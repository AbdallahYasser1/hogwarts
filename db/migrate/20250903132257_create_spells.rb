class CreateSpells < ActiveRecord::Migration[8.0]
  def change
    create_table :spells do |t|
      t.string :name, null: false
      t.text :description, null: false
      t.references :wizard, null: false, foreign_key: true
      t.timestamps
    end
    add_index :spells, [:wizard_id, :name], unique: true
  end
end
