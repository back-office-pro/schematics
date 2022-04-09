//= require js-routes
//= require slim-select/dist/slimselect
//= require_tree .
//= stub ./controllers/comparison_controller
//= stub ./controllers/dropdown_controller
//= stub ./controllers/form_controller
//= stub ./controllers/modal_controller
//= stub ./controllers/resizable_table_controller
//= stub ./controllers/sortable_controller
//= stub ./controllers/timeago_controller
//= stub ./controllers

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
