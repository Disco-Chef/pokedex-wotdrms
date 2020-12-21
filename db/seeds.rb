# last runs [266.666, 277.563, 141.108, 124.887, 112.916, 123.974]
Pokemon.destroy_all
Type.destroy_all
# EvolutionChain.destroy_all

# start_time = Time.now
puts "Creating Types..."
CreateFromPokeapi.new.create_types
puts ""
puts "Creating Pokemon..."
CreateFromPokeapi.new.create_pokemon
puts ""
# puts "Creating Evolution Chains..."
# CreateFromPokeapi.new.create_evolution_chains
# end_time = Time.now
# puts ""
# puts "It took: #{end_time - start_time} seconds this time"