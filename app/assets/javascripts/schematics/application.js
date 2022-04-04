//= require js-routes
//= require_tree .
//= stub ./timeago
//= stub ./stimulus

/* global Turbolinks */

document.addEventListener('turbolinks:load', function () {
  document
    .querySelectorAll('*[data-href]')
    .forEach(element => {
      element.addEventListener('click', function (e) {
        if (!e.target.closest('a, .btn-group, .best_in_place')) {
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
