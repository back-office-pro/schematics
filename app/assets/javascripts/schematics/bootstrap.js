//= require @popperjs/core/dist/umd/popper
//= require bootstrap/dist/js/bootstrap.bundle
//= require rails.validations
//= require rails.validations.simple_form.bootstrap4

/* global bootstrap */

document.addEventListener('turbolinks:load', function () {
  document
    .querySelectorAll('[data-bs-toggle="tooltip"]')
    .forEach(_ => new bootstrap.Tooltip(_))
  document
    .querySelectorAll('.toast')
    .forEach(_ => new bootstrap.Toast(_).show())
  document
    .querySelectorAll('.modal')
    .forEach(element => {
      element.addEventListener('show.bs.modal', function () {
        document.body.appendChild(this.parentNode)
      })
    })
})
