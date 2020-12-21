class PokemonsController < ApplicationController
  before_action :set_pokemon, only: [:show]
  def index
    if params[:search].present?
      name = params[:search]["name"]
      type = params[:search]["type"]
      if name.present? && type.present?
        @pokemons = Pokemon.filter_by_name_and_type(name, type)
      elsif name.present? && !type.present?
        @pokemons = Pokemon.filter_by_name(name)
      elsif !name.present? && type.present?
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
