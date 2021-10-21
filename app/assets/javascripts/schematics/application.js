//= require jquery/dist/jquery
//= require jquery-ujs/src/rails
//= require bootstrap/dist/js/bootstrap.bundle
//= require sweetalert2/dist/sweetalert2
//= require sweet-alert2-rails
//= require pagy
//= require font_awesome5
//= require rails-timeago
//= require locales/jquery.timeago.fr
//= require jquery-resizable-columns/dist/jquery.resizableColumns.min
//= require sortablejs/Sortable
//= require_tree .

/* global $, Pagy, Turbolinks, Sortable */

$(document).on('turbolinks:load', function () {
  Pagy.init()
  document.querySelectorAll('tbody').forEach(_ => Sortable.create(_))
  $('[data-toggle="tooltip"]').tooltip()
  $('.toast').toast({ delay: 5000 }).toast('show')
  $('table').resizableColumns()
  $('.custom-file-input').on('change', function () {
    $(this)
      .siblings('.custom-file-label')
      .addClass('selected')
      .html(Array.from($(this).get(0).files).map(_ => _.name).join(', '))
  })
  $('form.form-inline').on('submit', function () {
    return $(this)
      .find(':input')
      .filter(function () { return !this.value })
      .attr('disabled', true)
  })
  $('*[data-href]').on('click', function (e) {
    const $target = $(e.target)
    if (!$target.is('a') && !$target.parent().is('a') &&
            !$target.hasClass('best_in_place') && !$target.parents('.best_in_place').length) {
      Turbolinks.visit($(this).data('href'))
    }
  })
})

$(document).on('scroll', function () {
  const $nav = $('nav.navbar')
  if ($(window).scrollTop() > 50) {
    $nav.addClass('scrolled')
  } else {
    $nav.removeClass('scrolled')
  }
})
