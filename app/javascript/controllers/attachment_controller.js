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

/* global RAILS_ASSET_URL */

export default class extends ApplicationController {
  connect () {
    this.element.addEventListener('error', this.#replace.bind(this))
  }

  disconnect () {
    this.element.removeEventListener('error', this.#replace.bind(this))
  }

  #replace () {
    this.element.src = RAILS_ASSET_URL('/@fortawesome/fontawesome-free/svgs/solid/triangle-exclamation.svg')
    this.element.classList.add('attachment-error', 'h-25')
  }
}
