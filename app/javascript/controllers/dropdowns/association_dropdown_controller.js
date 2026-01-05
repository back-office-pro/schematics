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

export default class extends DropdownController {
  static get values () {
    return { url: { type: String }, field: { type: String } }
  }

  async #search (input, callback) {
    const url = `${this.urlValue}?filter[${this.fieldValue}]=${input}`
    const response = await this.fetchAPI(url)
    const results = await response.json()
    callback(results)
  }

  #isValid (input) {
    return this.element.options.length >= 100 && input.length >= 2
  }

  get options () {
    return Object.assign(super.options, {
      valueField: 'id',
      searchField: this.fieldValue,
      labelField: this.fieldValue,
      sortField: this.fieldValue,
      shouldLoad: this.#isValid.bind(this),
      load: this.#search.bind(this)
    })
  }
}
