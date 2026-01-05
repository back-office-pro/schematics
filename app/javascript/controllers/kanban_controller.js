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

import SortableController from 'controllers/sortable_controller'

export default class extends SortableController {
  static get values () {
    return Object.assign(super.values, {
      root: { type: String },
      attribute: { type: String }
    })
  }

  save (_) {}

  async #move ({ from, to, item, clone }) {
    const value = to.getAttribute('data-kanban-group-value')
    const id = item.getAttribute('data-id')
    const data = { [this.rootValue]: { [this.attributeValue]: value } }
    const response = await this.fetchAPI(`${window.location.pathname}/${id}`, 'PUT', data)
    if (!response.ok) {
      from.append(item)
      clone.remove()
    }
  }

  get options () {
    return Object.assign(super.options, {
      onAdd: this.#move.bind(this),
      sort: false
    })
  }
}
