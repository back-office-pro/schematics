//= require @popperjs/core/dist/umd/popper
//= require bootstrap/dist/js/bootstrap.bundle
//= require jquery/dist/jquery
//= require rails.validations
//= require rails.validations.simple_form.bootstrap4
//= require js-routes
//= require slim-select/dist/slimselect
//= require ./chartkick
//= require ./pagy
//= require ./swagger

/* global Turbo */

document.addEventListener('turbo:load', function () {
  document
    .querySelectorAll('*[data-href]')
    .forEach(element => {
      element.addEventListener('click', function (e) {
        if (!e.target.closest('a, .btn-group, [data-controller="edit-in-place"]')) {
          Turbo.visit(this.dataset.href)
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
