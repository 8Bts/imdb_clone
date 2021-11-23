const nav = (() => {

  const setAuthDropListiner = () => {
    const box = document.querySelector('.user-box-logged');
    const menu = document.querySelector('.auth-drop-menu');
    const dropIcon = document.querySelector('.drop-icon');

    if (!box) return;

    box.addEventListener('click', () => {
      menu.classList.toggle('d-none');
      const dValue = dropIcon.innerHTML;
      if (dValue === '▼') {
        dropIcon.innerHTML = '▲';
      } else {
        dropIcon.innerHTML = '▼';
      }
    });
  };

  return { setAuthDropListiner }
})();

export default nav;