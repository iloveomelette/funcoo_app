document.addEventListener('turbolinks:load', () => {
  const flash = document.getElementById('flash-wrapper');
  const close = document.getElementById('close');

  if (!close) {
    return false;
  }
  close.addEventListener('click', () => {
    flash.classList.add('hidden');
  });
});
