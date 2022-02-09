document.addEventListener('turbolinks:load', function () {
  document.querySelectorAll('.custom-file').forEach(element => {
    const input = element.querySelector('.custom-file-input')
    const label = element.querySelector('.custom-file-label')
    input.addEventListener('change', function () {
      label.textContent = Array.from(this.files).map(_ => _.name).join(', ')
    })
  })
  document.querySelectorAll('form').forEach(form => {
    form.addEventListener('submit', function () {
      const submitButton = this.querySelector('button[type="submit"]')
      submitButton.disabled = true
      submitButton.querySelectorAll('.icon').forEach(_ => _.classList.toggle('d-none'))
      submitButton.querySelectorAll('.text').forEach(_ => {
        _.classList.toggle(_.classList.contains('d-lg-inline') ? 'd-lg-inline' : 'd-none')
      })
    })
  })
  document.querySelectorAll('input[type="password"] + .input-group-append').forEach(input => {
    input.addEventListener('click', function () {
      this.previousSibling.setAttribute('type', this.previousSibling.type === 'text' ? 'password' : 'text')
      this.querySelectorAll('.icon').forEach(_ => _.classList.toggle('d-none'))
    })
  })
})
