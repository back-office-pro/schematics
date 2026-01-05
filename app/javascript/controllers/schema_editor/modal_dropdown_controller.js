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
  #setCollection () {
    if (this.inputs?.length) {
      this.element.tomselect.clearOptions()
      this.element.tomselect.addOptions(this.collection)
    }
  }

  get options () {
    return Object.assign(super.options, {
      onFocus: this.#setCollection.bind(this)
    })
  }

  get inputs () {
    return this
      .element
      .closest('.modal-body')
      ?.querySelectorAll('select[data-dropdown-create-value="true"] option:not([value=""])')
  }

  get collection () {
    return Array
      .from(this.inputs)
      .map(_ => _.value)
      .map(value => ({ value, text: value }))
      .sort((a, b) => a.value.localeCompare(b.value))
  }
}
