class CreateEvolutionChains < ActiveRecord::Migration[6.0]
  def change
    create_table :evolution_chains do |t|
      t.json :chain

      t.timestamps
    end
  end
end
