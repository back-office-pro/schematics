document.addEventListener('turbo:load', () => {
  document
    .querySelector('form#new_session')
    .addEventListener('submit', function () {
      this.querySelector('button[type="submit"]').disabled = true
    })
})
