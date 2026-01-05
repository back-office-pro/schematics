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
import Tribute from 'tributejs'

export default class extends ApplicationController {
  initialize () {
    this.tribute = new Tribute(this.options)
    this.tribute.attach(this.element)
  }

  get inputs () {
    return this
      .parentElement
      .closest('.schema-editor-entity')
      .querySelectorAll('.entity-field-name')
  }

  get modalId () {
    return this
      .element
      .closest('.modal')
      ?.getAttribute('id')
  }

  get parentElement () {
    return this.modalId ? document.querySelector(`div[data-bs-target="#${this.modalId}"]`) : this.element
  }

  get collection () {
    return Array
      .from(this.inputs)
      .map(input => ({ key: input.value, value: input.value }))
      .sort((a, b) => a.value.localeCompare(b.value))
  }

  get options () {
    return {
      trigger: '$',
      values: (_, callback) => callback(this.collection),
      containerClass: 'tribute-container list-group list-group-striped shadow-sm',
      itemClass: 'list-group-item list-group-item-action p-2 border-0 text-start text-truncate',
      menuItemLimit: 5,
      noMatchTemplate: () => null
    }
  }
}
