# last runs [266.666, 277.563, 141.108, 124.887, 112.916, 123.974]
start_time = Time.now
puts "Creating Types..."
CreateFromPokeapi.new.create_types()
puts "Creating Pokemon..."
CreateFromPokeapi.new.create_pokemon()
end_time = Time.now
puts (end_time - start_time)