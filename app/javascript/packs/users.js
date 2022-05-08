document.addEventListener('turbolinks:load', () => {
  const menuItems = document.querySelectorAll('.myRecipes-menu li a');
  const contents = document.querySelectorAll('.myRecipes-contents');
  const myRecipesActive = 'myRecipes-active';
  function removeClass(arry) {
    arry.forEach((item) => {
      item.classList.remove(myRecipesActive);
    });
  }

  if (!menuItems) {
    return false;
  }
  menuItems.forEach((clickedItem) => {
    clickedItem.addEventListener('click', (e) => {
      e.preventDefault();

      removeClass(menuItems);
      clickedItem.classList.add(myRecipesActive);

      removeClass(contents);
      document.getElementById(clickedItem.dataset.id).classList.add(myRecipesActive);
    });
  });
});
