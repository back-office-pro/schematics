$(document).on('turbolinks:load', function () {
  $('.switch-theme').on('click', function () {
    const $themes = $('link[href*=themes]')
    const $inactive = $themes.filter('[disabled="disabled"]')
    const $active = $themes.filter(':not([disabled="disabled"])')
    $inactive.removeAttr('disabled')
    setTimeout(() => $active.attr('disabled', 'disabled'), 10)
    $.ajax({
      url: '/preferences',
      type: 'PUT',
      data: JSON.stringify({ preferences: { theme: $inactive.attr('id') } }),
      contentType: 'application/json',
      dataType: 'json'
    })
  })
})
