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

import ApplicationController from 'controllers/application_controller'
import TomSelect from 'tom-select'

/* global I18n */

export default class extends ApplicationController {
  initialize () {
    new TomSelect(this.element, this.options) // eslint-disable-line no-new
  }

  static get values () {
    return {
      create: { type: Boolean, default: false },
      createFilter: { type: String }
    }
  }

  #setDependentDropdownsOptions (value) {
    document
      .querySelectorAll(`[data-dropdown-depends-on="${this.element.name}"]`)
      .forEach(element => {
        value && element.tomselect.clear()
        element.tomselect.clearOptions()
        element.tomselect.addOptions(
          Array
            .from(element.options)
            .filter(option => option.value.startsWith(value?.concat('#')))
            .map(option => ({ value: option.value, text: option.text }))
        )
      })
  }

  get options () {
    return {
      plugins: ['no_active_items', 'no_backspace_delete', this.removable && 'remove_button'],
      itemClass: this.multiple ? 'item bg-primary text-white' : 'item',
      onInitialize: this.debounce(this.#setDependentDropdownsOptions),
      onChange: this.#setDependentDropdownsOptions.bind(this),
      maxOptions: null,
      create: this.createValue,
      createOnBlur: this.createValue,
      createFilter: this.createFilterValue,
      render: {
        no_results: () => `<div class="option opacity-100 text-body-secondary">
          <i class="fa fa-exclamation-triangle text-secondary me-2"></i>
          ${I18n.typeahead.notFound}
        </div>`,
        loading: () => `<div class="option opacity-100 text-body-secondary">
          <i class="fa fa-spinner fa-spin text-secondary me-2"></i>
          ${I18n.typeahead.pending}
        </div>`,
        option_create: (data, escape) => `<div class="create option opacity-100">
          ${I18n.typeahead.add} <strong>${escape(data.input)}</strong>&hellip;
        </div>`
      }
    }
  }

  get removable () {
    return !this.required || this.multiple
  }

  get required () {
    return this.element.getAttribute('required') === 'required'
  }

  get multiple () {
    return this.element.getAttribute('multiple') === 'multiple'
  }
}
