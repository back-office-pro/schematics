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

/* global localStorage */

export default class extends ApplicationController {
  static get targets () {
    return ['online', 'offline']
  }

  initialize () {
    this.#sync()
  }

  connect () {
    window.addEventListener('online', this.#toggle.bind(this))
    window.addEventListener('online', this.#sync.bind(this))
    window.addEventListener('offline', this.#toggle.bind(this))
  }

  disconnect () {
    window.removeEventListener('online', this.#toggle.bind(this))
    window.removeEventListener('online', this.#sync.bind(this))
    window.removeEventListener('offline', this.#toggle.bind(this))
  }

  #toggle () {
    this.onlineTarget.classList.toggle('d-none')
    this.offlineTarget.classList.toggle('d-none')
  }

  #sync () {
    for (const [key, value] of Object.entries({ ...localStorage })) {
      if (key.startsWith('sync:')) {
        this.fetchAPI(...JSON.parse(value))
      }
    }
  }
}
