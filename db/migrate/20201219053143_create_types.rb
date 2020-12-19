class CreateTypes < ActiveRecord::Migration[6.0]
  def change
    create_table :types do |t|
      t.string :name
      t.json :damage_relations

      t.timestamps
    end
  end
end
