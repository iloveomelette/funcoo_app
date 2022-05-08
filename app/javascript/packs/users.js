document.addEventListener('turbolinks:load', () => {
  const menuItems = document.querySelectorAll('.myRecipes-menu li a');
  const contents = document.querySelectorAll('.myRecipes-contents');

  if (!menuItems) {
    return false;
  }
  menuItems.forEach((clickedItem) => {
    clickedItem.addEventListener('click', (e) => {
      e.preventDefault();

      menuItems.forEach((item) => {
        item.classList.remove('myRecipes-active');
      });
      clickedItem.classList.add('myRecipes-active');

      contents.forEach((content) => {
        content.classList.remove('myRecipes-active');
      });
      document.getElementById(clickedItem.dataset.id).classList.add('myRecipes-active');
    });
  });
});
