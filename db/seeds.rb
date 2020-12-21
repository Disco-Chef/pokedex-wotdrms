# last runs [330.596]
Pokemon.destroy_all
Type.destroy_all
EvolutionChain.destroy_all

start_time = Time.now
puts "Creating Types..."
CreateFromPokeapi.new.create_types
puts ""
puts "Creating Pokemon..."
CreateFromPokeapi.new.create_pokemon
puts ""
puts "Creating Evolution Chains..."
CreateFromPokeapi.new.create_evolution_chains
end_time = Time.now
puts ""
puts "It took: #{end_time - start_time} seconds this time"