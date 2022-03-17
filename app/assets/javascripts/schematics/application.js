//= require jquery/dist/jquery
//= require jquery-ujs/src/rails
//= require popper.js/dist/umd/popper
//= require bootstrap/dist/js/bootstrap.bundle
//= require rails.validations
//= require rails.validations.simple_form.bootstrap4
//= require sweetalert2/dist/sweetalert2
//= require sweet-alert2-rails
//= require pagy
//= require font_awesome5
//= require rails-timeago
//= require locales/jquery.timeago.fr
//= require jquery-resizable-columns/dist/jquery.resizableColumns.min
//= require sortablejs/Sortable
//= require js-routes
//= require_tree .

/* global $, Pagy, Turbolinks, Sortable */

document.addEventListener('turbolinks:load', function () {
  $('[data-toggle="tooltip"]').tooltip()
  $('.toast').toast({ delay: 5000 }).toast('show')
  $('table').resizableColumns()
  Pagy.init()
  document.querySelectorAll('tbody').forEach(Sortable.create)
  $('*[data-href]').on('click', function (e) {
    const $target = $(e.target)
    if (!$target.is('a') &&
        !$target.parents('a').length &&
        !$target.parents('.btn-group').length &&
        !$target.hasClass('best_in_place') &&
        !$target.parents('.best_in_place').length) {
      Turbolinks.visit($(this).data('href'))
    }
  })
})

document.addEventListener('scroll', function () {
  const classList = document.querySelector('nav.navbar').classList
  window.scrollY > 25 ? classList.add('scrolled') : classList.remove('scrolled')
})
