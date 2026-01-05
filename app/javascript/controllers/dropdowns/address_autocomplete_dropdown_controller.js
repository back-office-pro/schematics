/*
 * Copyright © 2025 Dev & Software. All rights reserved.
 *
 * THIS SOFTWARE IS PROPRIETARY AND CONFIDENTIAL. UNAUTHORIZED COPYING, DISTRIBUTION, MODIFICATION,
 * REVERSE ENGINEERING, OR DISCLOSURE IS STRICTLY PROHIBITED.
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT
 * NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE, AND
 * NONINFRINGEMENT.
 * IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES, OR OTHER
 * LIABILITY ARISING FROM, OUT OF, OR IN CONNECTION WITH THE SOFTWARE OR ITS USE.
 */

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
