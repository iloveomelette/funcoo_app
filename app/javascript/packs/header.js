document.addEventListener('turbolinks:load', () => {
  const spNavOpen = document.getElementById('sp-navOpen');
  const mdNavOpen = document.getElementById('md-navOpen');
  const overlay = document.querySelector('.overlay');
  const mdNavWrapper = document.querySelector('.md-navWrapper');
  const spNavclose = document.getElementById('sp-navclose');

  if (!spNavOpen) {
    return false;
  }
  spNavOpen.addEventListener('click', () => {
    overlay.classList.add('show');
    spNavOpen.classList.add('hide');
  });
  spNavclose.addEventListener('click', () => {
    overlay.classList.remove('show');
    spNavOpen.classList.remove('hide');
  });
  mdNavOpen.addEventListener('click', () => {
    mdNavWrapper.classList.toggle('show');
  });
});
