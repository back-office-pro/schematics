document.addEventListener('turbolinks:load', function () {
  document.querySelectorAll('form').forEach(form => {
    form.addEventListener('submit', function () {
      const submitButton = this.querySelector('button[type="submit"]')
      if (submitButton != null) {
        submitButton.disabled = true
        submitButton.querySelectorAll('.icon').forEach(_ => _.classList.toggle('d-none'))
        submitButton.querySelectorAll('.text').forEach(_ => {
          _.classList.toggle(_.classList.contains('d-lg-inline') ? 'd-lg-inline' : 'd-none')
        })
      }
    })
  })
  document.querySelectorAll('input[type="password"] + .input-group-text').forEach(input => {
    input.addEventListener('click', function () {
      this.previousSibling.setAttribute('type', this.previousSibling.type === 'text' ? 'password' : 'text')
      this.querySelectorAll('.icon').forEach(_ => _.classList.toggle('d-none'))
    })
  })
})
