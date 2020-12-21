class Pokemon < ApplicationRecord
  has_many :pokemon_types
  has_many :types, through: :pokemon_types
  belongs_to :evolution_chain, optional: true

  def self.filter_by_name(name)
    sql_query = "pokemons.name ILIKE :name"
    return Pokemon.where(sql_query, name: "%#{name}%").order(:id)
  end

  def self.filter_by_type(type)
    return Type.find_by(name: type).pokemons
  end

  def self.filter_by_name_and_type(name, type)
    sql_query = "pokemons.name ILIKE :name"
    return Type.find_by(name: type).pokemons.where(sql_query, name: "%#{name}%").order(:id)
  end
end
