import DropdownController from '../dropdown_controller'

/* global google */

export default class extends DropdownController {
  async getPlacePredictions (input, callback) {
    if (this.isValid(input)) {
      const predictions = [{ text: input }]
      try {
        const { predictions } = await this.service.getPlacePredictions({ input })
        callback(predictions.map(prediction => ({ text: prediction.description })))
      } catch {
        callback(predictions)
      }
    }
  }

  isValid (input) {
    return input.length >= this.element.getAttribute('minlength')
  }

  get service () {
    return new google.maps.places.AutocompleteService()
  }

  get options () {
    return Object.assign(super.options, {
      ajax: this.getPlacePredictions.bind(this)
    })
  }
}
