class CreateFromPokeapi
  def initialize
    @base_url = "http://pokeapi.co/api/v2"
  end

  def create_pokemon
    (878..893).each do |pokemon_id|
      p "#{@base_url}/pokemon/#{pokemon_id}."
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
      pokemon = Pokemon.create!(pokemon_build_attributes)
      pokemon_data['types'].each do |type|
        pokemon.types << Type.find_by(name: type['type']['name'])
      end
      p pokemon.id
      p "."
    end
  end

  def create_types
    (1..18).each do |type_id|
      type_data = JSON.parse(RestClient.get("#{@base_url}/type/#{type_id}"))
      type_build_attributes = {
        name: type_data['name']
      }
      type = Type.create(type_build_attributes)
      p type.id
      p "."
    end
  end

  def fetch_description_from_pokemon_species_endpoint(pokemon_id)
    species_data = JSON.parse(RestClient.get("#{@base_url}/pokemon-species/#{pokemon_id}"))
    species_data["flavor_text_entries"].each do |text_entry|
      if text_entry.dig("language", "name") == "en"
        return text_entry["flavor_text"].gsub("\n", " ").gsub("POKéMON", "Pokémon").gsub("\f", " ")
      end
    end
  end

  def create_evolution_chains
    chain_hash = {}
    (1..470).each do |evolution_id|
      RestClient.get("#{@base_url}/evolution-chain/#{evolution_id}") { |response|
        case response.code
        when 200
          chain_data = JSON.parse(response)
          chain_starting_pokemon = chain_data["chain"]["species"]["name"]
          chain_hash["first"] = [chain_starting_pokemon]
          if chain_data["chain"]["evolves_to"].present?
            second_level_pokemons = []
            third_level_pokemons = []
            chain_data["chain"]["evolves_to"].each do |second_level_evolution|
              second_level_pokemons << second_level_evolution["species"]["name"]
              if second_level_evolution["evolves_to"].present?
                second_level_evolution["evolves_to"].each do |third_level_evolution|
                  third_level_pokemons << third_level_evolution["species"]["name"]
                end
              end
            end
          end
        when 404
          next
        end
        chain_hash["second"] = second_level_pokemons
        chain_hash["third"] = third_level_pokemons
        chain_instance = EvolutionChain.create(chain: chain_hash)
        associate_pokemon_to_chain(chain_hash, chain_instance)
      }
      p chain_instance.id
      p chain_instance.chain
    end
  end

  def associate_pokemon_to_chain(chain_hash, chain_instance)
    chain_hash.each_value do |pokemon_array_in_level|
      if pokemon_array_in_level.present?
        pokemon_array_in_level.each do |species_name|
          Pokemon.find_by(species: species_name).update(evolution_chain: chain_instance)
        end
      end
    end
  end
end
