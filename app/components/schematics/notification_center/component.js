/* global $ */

$(document).on('turbolinks:load', function () {
  $('#notifications-dropdown').has('.badge').on('click', function () {
    const $element = $(this)
    $.post('/dashboard/read_notifications', function () {
      $element
        .find('.badge')
        .fadeOut()
        .end()
        .find('.animate__animated')
        .removeClass('animate__animated text-primary')
    })
  })
})
