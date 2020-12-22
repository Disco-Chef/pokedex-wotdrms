// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

require("@rails/ujs").start()
require("turbolinks").start()
require("@rails/activestorage").start()
require("channels")


// Uncomment to copy all static images under ../images to the output folder and reference
// them with the image_pack_tag helper in views (e.g <%= image_pack_tag 'rails.png' %>)
// or the `imagePath` JavaScript helper below.
//
// const images = require.context('../images', true)
// const imagePath = (name) => images(name, true)


// ----------------------------------------------------
// Note(lewagon): ABOVE IS RAILS DEFAULT CONFIGURATION
// WRITE YOUR OWN JS STARTING FROM HERE 👇
// ----------------------------------------------------

// External imports
import "bootstrap";

// Internal imports, e.g:
// import { initSelect2 } from '../components/init_select2';

document.addEventListener('turbolinks:load', () => {
  currentPage();
  refreshFavoriteButtonType();
  loadFavoritizor();
});

let myStorage = window.sessionStorage;

const currentPage = () => {
  let viewPage = document.getElementById("js-page-identifier").dataset.currentPage;
  return viewPage;
}

const toggleFavorite = (event) => {
  console.log("Event Triggered!")
  let favoritesArray = setFavoritesArray();
  let pokemonId = event.currentTarget.dataset.pokemonId;
  if (!myStorage.favorites) {
    myStorage.favorites = pokemonId;
    addFavoriteStyle(event.currentTarget);
    console.log(window.sessionStorage)
    refreshFavoriteButtonType();
    return
  }
  if (favoritesArray.includes(pokemonId)) {
    let favoriteToRemoveIndex = favoritesArray.indexOf(pokemonId);
    favoritesArray.splice(favoriteToRemoveIndex, 1);
    myStorage.favorites = favoritesArray.join(",");
    removeFavoriteStyle(event.currentTarget);
    console.log(window.sessionStorage)
    refreshFavoriteButtonType();
    return
  }
  myStorage.favorites += `,${pokemonId}`;
  addFavoriteStyle(event.currentTarget);
  console.log(window.sessionStorage)
  refreshFavoriteButtonType();
  return
}

const refreshFavoriteButtonType = () => {
  if (myStorage.favorites) {
    let favoritesArray = setFavoritesArray();
    console.log(favoritesArray);
    favoritesArray.forEach((favoriteId) => {
      document.querySelectorAll(`#pokemon-id-${favoriteId}`).forEach((favoriteButton) => {
        addFavoriteStyle(favoriteButton);
      })
    })
    if (currentPage() == "show") {
      document.querySelectorAll(".button-toggle-favorite").forEach((favoriteButton) => {
        if (!favoritesArray.includes(favoriteButton.dataset.pokemonId)) {
          removeFavoriteStyle(favoriteButton);
        }
      })
    }
  }
  else {
    document.querySelectorAll(".button-toggle-favorite").forEach((favoriteButton) => {
      removeFavoriteStyle(favoriteButton);
    })
  }
}

const setFavoritesArray = () => {
  let favoritesArray;
  if (myStorage.favorites) {
    favoritesArray = myStorage.favorites.split(",");
    return favoritesArray;
  }
  else {
    return favoritesArray = []
  }
}

const addFavoriteStyle = (domObject) => {
  domObject.classList.add("fas", 'favorite');
  domObject.classList.remove("far");
}

const removeFavoriteStyle = (domObject) => {
  domObject.classList.remove("fas");
  domObject.classList.add("far", "favorite");
}

const loadFavoritizor = () => {
  let buttonToggleFavorite = document.querySelectorAll('.fa-heart');
    buttonToggleFavorite.forEach((button) => {
    button.addEventListener('click', toggleFavorite);
  })
}