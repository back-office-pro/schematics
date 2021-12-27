//= require slim-select/dist/slimselect

/* global $, SlimSelect, I18n */

$(document).on('turbolinks:load', function () {
  document.querySelectorAll('.simple_form select').forEach(element => {
    new SlimSelect({ // eslint-disable-line no-new
      select: element,
      searchText: I18n.slimSelect.searchText,
      searchPlaceholder: I18n.slimSelect.searchPlaceholder,
      placeholder: I18n.slimSelect.placeholder,
      searchFocus: true,
      searchHighlight: true
    })
  })
})
