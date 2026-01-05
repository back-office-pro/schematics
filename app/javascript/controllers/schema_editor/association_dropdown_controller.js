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
  initialize () {
    super.initialize()
    this.initialCollection = this.element.tomselect.options
  }

  #setCollection () {
    this.element.tomselect.clearOptions()
    this.element.tomselect.addOptions(this.initialCollection)
    this.element.tomselect.addOptions(this.collection)
  }

  get options () {
    return Object.assign(super.options, {
      onFocus: this.#setCollection.bind(this),
      sortField: 'value'
    })
  }

  get inputs () {
    return document.querySelectorAll('.entity-name')
  }

  get collection () {
    return Array
      .from(this.inputs)
      .map(_ => _.value)
      .map(value => ({ value, text: value }))
  }
}
