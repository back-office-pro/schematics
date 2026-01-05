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

/* global Turbo, routes */

export default class extends ApplicationController {
  static get targets () {
    return ['button', 'switch']
  }

  async submit () {
    this.buttonTarget.disabled = true
    const response = await this.fetchAPI(this.url, 'POST', this.params)
    Turbo.visit(response.headers.get('Location'))
  }

  toggleButton () {
    if (this.hasButtonTarget) {
      this.buttonTarget.classList.toggle('d-none', this.ids().length < 2)
    }
  }

  ids () {
    return this
      .switchTargets
      .filter(_ => _.checked)
      .map(_ => _.name)
  }

  get params () {
    return { bulk_action: { ids: this.ids() } }
  }

  get url () {
    return `${window.location.pathname}/${routes.bulkActions}`
  }
}
