document.addEventListener('turbolinks:load', () => {
  const open = document.getElementById('open');
  const overlay = document.querySelector('.overlay');
  const close = document.getElementById('sp-navclose');

  if (!open) {
    return false;
  }
  open.addEventListener('click', () => {
    overlay.classList.add('show');
    open.classList.add('hide');
  });
  close.addEventListener('click', () => {
    overlay.classList.remove('show');
    open.classList.remove('hide');
  });
});
