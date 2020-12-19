class CreateFromPokeapi
  def initialize
    @base_url = 'https://pokeapi.co/api/v2'
  end

  def create_pokemon(pokemon_count = nil)
    all_pokemon_count = 893
    pokemon_count ||= all_pokemon_count
    (1..pokemon_count).each do |pokemon_id|
      pokemon_data = JSON.parse(RestClient.get("#{@base_url}/pokemon/#{pokemon_id}"))
      pokemon_build_attributes = {
        name: pokemon_data['name'],
        description: fetch_description_from_pokemon_species_endpoint(pokemon_id),
        height: pokemon_data['height'],
        weight: pokemon_data['weight'],
        species: pokemon_data['species']['name'],
        hp: pokemon_data['stats'][0]['base_stat'],
        attack: pokemon_data['stats'][1]['base_stat'],
        defense: pokemon_data['stats'][2]['base_stat'],
        special_attack: pokemon_data['stats'][3]['base_stat'],
        special_defense: pokemon_data['stats'][4]['base_stat'],
        speed: pokemon_data['stats'][4]['base_stat'],
        sprite_url: pokemon_data['sprites']['other']['official-artwork']['front_default']
      }
      pokemon = Pokemon.create(pokemon_build_attributes)
      pokemon_data['types'].each do |type| # wow, thanks again for the reminder, you wonderful
        pokemon.types << Type.find_by(name: type['type']['name']) # man you o/
      end
      print(pokemon.id)
      print(".")
    end
  end

  def create_types
    (1..18).each do |type_id|
      type_data = JSON.parse(RestClient.get("#{@base_url}/type/#{type_id}"))
      type_build_attributes = {
        name: type_data['name']
      }
      Type.create(type_build_attributes)
    end
    print(".")
  end

  def fetch_description_from_pokemon_species_endpoint(pokemon_id)
    species_data = JSON.parse(RestClient.get("#{@base_url}/pokemon-species/#{pokemon_id}"))
    species_data["flavor_text_entries"].each do |text_entry|
      return text_entry["flavor_text"].gsub("\n", " ").gsub("POKéMON", "Pokémon").gsub("\f", " ") if text_entry.dig("language", "name") == "en"
    end
  end
end
