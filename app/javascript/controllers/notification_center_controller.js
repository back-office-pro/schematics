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

/* global routes */

export default class extends ApplicationController {
  static get targets () {
    return ['badge', 'icon']
  }

  readNotifications () {
    if (this.#hasNotifications()) {
      this.fetchAPI(routes.userNotifications, 'PUT')
      this.badgeTarget.classList.remove('animate__zoomIn')
      this.badgeTarget.classList.add('animate__fadeOut')
      this.iconTarget.classList.remove('animate__animated')
    }
  }

  #hasNotifications () {
    return this.targets.has('badge') && this.badgeTarget.classList.contains('animate__zoomIn')
  }
}
