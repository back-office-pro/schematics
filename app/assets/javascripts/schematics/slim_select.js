//= require slim-select/dist/slimselect

/* global $, SlimSelect, I18n */

$(document).on('turbolinks:load', function () {
  document.querySelectorAll('.simple_form select').forEach(element => {
    new SlimSelect({ // eslint-disable-line no-new
      select: element,
      searchText: I18n.slim_select.search_text,
      searchPlaceholder: I18n.slim_select.search_placeholder,
      placeholder: I18n.slim_select.placeholder,
      searchFocus: true,
      searchHighlight: true
    })
  })
})
