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

/* global FormData, File, routes */

export default class extends ApplicationController {
  static get outlets () {
    return ['timeago']
  }

  static get targets () {
    return ['form', 'button', 'restoreButton']
  }

  static get values () {
    return { draft: Object }
  }

  connect () {
    this.formTarget.addEventListener('change', this.debounce(this.#save))
  }

  disconnect () {
    this.formTarget.removeEventListener('change', this.debounce(this.#save))
  }

  restore () {
    this.#hideRestoreButton()
    Object
      .entries(this.draftValue.data)
      .forEach(([key, value]) => {
        const input = this.element.querySelector(`[name='${key}']`)
        input?.setAttribute('value', value)
        input?.tomselect?.setValue(value)
      })
  }

  async #save () {
    this.fetchAPI(this.url, 'PUT', this.params)
    this.hasRestoreButtonTarget && this.#hideRestoreButton()
    this.buttonTarget.classList.remove('d-none')
    this.timeagoOutletElement.setAttribute('datetime', new Date().toJSON())
    this.timeagoOutlet.disconnect()
    this.timeagoOutlet.connect()
  }

  #hideRestoreButton () {
    this.restoreButtonTarget.classList.add('d-none')
  }

  get params () {
    return { draft: { data: this.filteredFormData } }
  }

  get url () {
    return routes.draft.replace(':id', this.draftValue.id)
  }

  get formData () {
    return Object.fromEntries(new FormData(this.formTarget))
  }

  get filteredFormData () {
    return Object.fromEntries(
      Object
        .entries(this.formData)
        .filter(([key, _]) => !this.denylist.some(_ => key.includes(_)))
        .filter(([_, value]) => !(value instanceof File))
        .filter(([_, value]) => value !== '')
    )
  }

  get denylist () {
    return ['authenticity_token', '_method', 'password', 'lock_version']
  }
}
