import { Controller } from '../@hotwired/stimulus/dist/stimulus'

/* global SlimSelect, I18n, google */

export class DropdownController extends Controller {
  static get values () {
    return {
      addressAutocomplete: { type: Boolean, default: false },
      dependsOn: String
    }
  }

  connect () {
    new SlimSelect(this.options) // eslint-disable-line no-new
  }

  disconnect () {
    this.element.slim.destroy()
  }

  async getPlacePredictions (input, callback) {
    if (this.isValid(input)) {
      const predictions = [{ text: input }]
      try {
        const { predictions } = await this.service.getPlacePredictions({ input })
        callback(predictions.map(prediction => ({ text: prediction.description })))
      } catch (e) {
        callback(predictions)
      }
    }
  }

  setDependentDropdownsOptions ({ value }) {
    document
      .querySelectorAll(`[data-dropdown-depends-on-value="${this.element.name}"]`)
      .forEach(element => {
        element.slim.setData(
          Array
            .from(element.options)
            .map(option => {
              return {
                value: option.value,
                text: option.innerText,
                class: !option.value.startsWith(value) && 'd-none'
              }
            })
        )
        element.value = null
      })
  }

  isValid (input) {
    return input.length >= this.element.getAttribute('minlength')
  }

  get service () {
    return new google.maps.places.AutocompleteService()
  }

  get options () {
    return {
      select: this.element,
      ajax: this.addressAutocompleteValue && this.getPlacePredictions.bind(this),
      onChange: this.setDependentDropdownsOptions.bind(this),
      searchingText: I18n.typeahead.pending,
      searchText: I18n.slimSelect.searchText,
      searchPlaceholder: I18n.slimSelect.searchPlaceholder,
      placeholder: I18n.slimSelect.placeholder,
      searchFocus: true,
      searchHighlight: true,
      showSearch: true
    }
  }
}
