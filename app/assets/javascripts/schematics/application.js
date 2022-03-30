//= require jquery/dist/jquery
//= require jquery-ujs/src/rails
//= require @popperjs/core/dist/umd/popper
//= require bootstrap/dist/js/bootstrap.bundle
//= require rails.validations
//= require rails.validations.simple_form.bootstrap4
//= require sweetalert2/dist/sweetalert2
//= require sweet-alert2-rails
//= require pagy
//= require @fortawesome/fontawesome-free/js/all
//= require rails-timeago
//= require locales/jquery.timeago.fr
//= require sortablejs/Sortable
//= require js-routes
//= require_tree .

/* global Pagy, Turbolinks, Sortable, bootstrap */

document.addEventListener('turbolinks:load', function () {
  Pagy.init()
  document
    .querySelectorAll('[data-bs-toggle="tooltip"]')
    .forEach(_ => new bootstrap.Tooltip(_))
  document
    .querySelectorAll('.toast')
    .forEach(_ => new bootstrap.Toast(_).show())
  document
    .querySelectorAll('tbody')
    .forEach(Sortable.create)
  document
    .querySelectorAll('*[data-href]')
    .forEach(element => {
      element.addEventListener('click', function (e) {
        if (['TD', 'DIV'].includes(e.target.nodeName)) {
          Turbolinks.visit(this.dataset.href)
        }
      })
    })
})

document.addEventListener('scroll', function () {
  const navbar = document.querySelector('nav.navbar')
  if (navbar != null) {
    window.scrollY > 25 ? navbar.classList.add('scrolled') : navbar.classList.remove('scrolled')
  }
})
