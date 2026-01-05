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
import Sortable from 'sortablejs'

/* global routes */

export default class extends ApplicationController {
  static get values () {
    return {
      group: { type: String },
      targets: { type: Array, default: [] }
    }
  }

  connect () {
    Sortable.create(this.element, this.options)
  }

  save (sortable) {
    if (this.groupValue !== '') {
      const preferences = { [this.groupValue]: sortable.toArray() }
      this.fetchAPI(routes.preferences, 'PUT', { user: { preferences } })
    }
  }

  get options () {
    return {
      filter: '.sortable-disabled, input',
      draggable: '.cursor-grab',
      preventOnFilter: false,
      animation: 150,
      ghostClass: 'opacity-50',
      group: { name: this.groupValue, put: this.targetsValue },
      store: { set: this.save.bind(this) }
    }
  }
}
