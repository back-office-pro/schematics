//= require jquery/dist/jquery
//= require best_in_place
//= require jquery-ui/ui/effect
//= require jquery-ui/ui/effects/effect-highlight
//= require jquery-ui/ui/widgets/datepicker
//= require jquery-ui/ui/i18n/datepicker-fr
//= require best_in_place.jquery-ui

/* global $ */

$(document).on('turbolinks:load', function () {
  $('.best_in_place').best_in_place()
  $('.best_in_place').on('ajax:success', function () {
    $(this).closest('td').effect('highlight')
  })
})

$(document).on('best_in_place:error', function (event, request) {
  const $target = $(event.target).parent()
  const response = JSON.parse(request.responseText)
  let i = 0
  for (const key in response) {
    const $element = $(`<div class='invalid-feedback'>${response[key]}</div>`)
    $target.append($element)
    $element.delay(1000 * i).slideDown().delay(3000 + 1000 * i).slideUp()
    i++
  }
})
