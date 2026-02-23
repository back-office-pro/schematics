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

/* global I18n */

export default class extends ApplicationController {
  static get values () {
    return { version: String }
  }

  static get targets () {
    return ['icon', 'text']
  }

  async connect () {
    const response = await fetch('https://www.back-office.pro/latest')
    const { version } = await response.json()
    this.iconTarget.classList.remove('fa-spinner', 'fa-spin')
    if (version === this.versionValue) {
      this.textTarget.textContent = I18n.softwareUpdate.upToDate
      this.iconTarget.classList.add('fa-cloud-arrow-up')
    } else {
      this.textTarget.textContent = I18n.softwareUpdate.outdated
      this.iconTarget.classList.add('fa-triangle-exclamation')
    }
  }
}
