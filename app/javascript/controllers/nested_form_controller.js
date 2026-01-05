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

/* global crypto */

export default class extends ApplicationController {
  static get targets () {
    return ['targets', 'templates']
  }

  add ({ params: { templateId, targetId, index } }) {
    const timestamp = new Date().getTime().toString()
    const template = this.templatesTargets.find(_ => _.id === templateId)
    const target = this.targetsTargets.find(_ => _.id === targetId)
    const content = template
      .innerHTML
      .replace(/NEW_RECORD/g, timestamp)
      .replace(/RANDOM_UUID/g, crypto.randomUUID())
      .replace(/INDEX/g, index ?? timestamp)
    target.insertAdjacentHTML('afterbegin', content)
  }

  remove ({ target, params }) {
    target.closest(params.wrapper).remove()
  }
}
