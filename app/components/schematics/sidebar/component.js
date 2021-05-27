/* global $ */

$(document).on('turbolinks:load', function () {
  $('#sidebar-toggle').on('click', function () {
    $('.sidebar, .content').toggleClass('toggled')
    $('.sidebar .d-none').toggleClass('d-md-block')
    $.ajax({
      url: '/preferences',
      type: 'PUT',
      data: JSON.stringify({ preferences: { sidebar_toggled: $('.sidebar').hasClass('toggled') } }),
      contentType: 'application/json',
      dataType: 'json'
    })
  })
})
