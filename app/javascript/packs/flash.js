document.addEventListener('turbolinks:load', () => {
  const flash = document.getElementById('flash-wrapper');
  const close = document.getElementById('close');

  close.addEventListener('click', () => {
    flash.classList.add('hidden');
  });
});
