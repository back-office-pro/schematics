//= require slim-select/dist/slimselect

/* global SlimSelect, I18n, google */

document.addEventListener('turbolinks:load', function () {
  document.querySelectorAll('.simple_form select').forEach(element => {
    const options = {
      searchingText: I18n.typeahead.pending,
      searchText: I18n.slimSelect.searchText,
      searchPlaceholder: I18n.slimSelect.searchPlaceholder,
      placeholder: I18n.slimSelect.placeholder,
      searchFocus: true,
      searchHighlight: true,
      showSearch: true
    }
    new SlimSelect({ // eslint-disable-line no-new
      select: element,
      ...options,
      onChange: ({ value }) => {
        document
          .querySelectorAll(`.simple_form select[data-depends-on="${element.name}"`)
          .forEach(element => {
            Array.from(element.options).forEach(_ => _.classList.add('d-none'))
            Array
              .from(element.options)
              .filter(_ => _.value.startsWith(value))
              .forEach(_ => _.classList.remove('d-none'))
            element.value = null
            element.slim.destroy()
            new SlimSelect({ select: element, ...options }) // eslint-disable-line no-new
          })
      },
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
