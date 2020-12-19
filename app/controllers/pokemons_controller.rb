class PokemonsController < ApplicationController
  def index
    @pokemons = Pokemon.all
  end

  def show
  end

  private

  def set_pokemon
    @pokemon = Pokemon.find(params[:id])
  end
end
