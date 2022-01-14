//= require slim-select/dist/slimselect

/* global $, SlimSelect, I18n, google */

$(document).on('turbolinks:load', function () {
  document.querySelectorAll('.simple_form select').forEach(element => {
    new SlimSelect({ // eslint-disable-line no-new
      select: element,
      searchingText: I18n.typeahead.pending,
      searchText: I18n.slimSelect.searchText,
      searchPlaceholder: I18n.slimSelect.searchPlaceholder,
      placeholder: I18n.slimSelect.placeholder,
      searchFocus: true,
      searchHighlight: true,
      showSearch: true,
      ...(element.classList.contains('address_autocomplete') && {
        ajax: async (input, callback) => {
          if (input.length >= element.getAttribute('minlength')) {
            const service = new google.maps.places.AutocompleteService()
            service.getPlacePredictions({ input }, (predictions, status) => {
              callback(
                (status !== google.maps.places.PlacesServiceStatus.OK || !predictions)
                  ? [{ text: input }]
                  : predictions.map(prediction => ({ text: prediction.description }))
              )
            })
          }
        }
      })
    })
  })
})
