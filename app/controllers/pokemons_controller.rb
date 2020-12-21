class PokemonsController < ApplicationController
  before_action :set_pokemon, only: [:show]
  def index
    if params[:search].present?
      name_is_present = params[:search]["name"].present?
      type_is_present = params[:search]["type"].present?
      if name_is_present && type_is_present
        @pokemons = Pokemon.filter_by_name_and_type(name, type)
      elsif name_is_present && !type_is_present
        @pokemons = Pokemon.filter_by_name(name)
      elsif !name_is_present && type_is_present
        @pokemons = Pokemon.filter_by_type(type)
      else
        @pokemons = Pokemon.all
      end
    else
      @pokemons = Pokemon.all
    end
  end

  def show
  end

  private

  def set_pokemon
    @pokemon = Pokemon.find(params[:id])
  end
end
