import DropdownController from 'controllers/dropdown_controller'

/* global google */

export default class extends DropdownController {
  async #getPlacePredictions (input, callback) {
    try {
      const { predictions } = await this.service.getPlacePredictions({ input })
      callback(predictions)
    } catch {
      const predictions = [{ description: input }]
      callback(predictions)
    }
  }

  #isValid (input) {
    return input.length >= 3
  }

  get service () {
    return new google.maps.places.AutocompleteService()
  }

  get options () {
    return Object.assign(super.options, {
      valueField: 'description',
      searchField: 'description',
      labelField: 'description',
      sortField: 'description',
      shouldLoad: this.#isValid,
      load: this.#getPlacePredictions.bind(this)
    })
  }
}
