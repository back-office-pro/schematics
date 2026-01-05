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

export default class extends ApplicationController {
  static get targets () {
    return ['digit']
  }

  connect () {
    this.digitTargets[0].focus()
  }

  input (event) {
    const { target, data } = event
    const { value } = target
    if (isNaN(value) || data === null) {
      target.value = ''
    } else {
      this.navigateRight(event)
    }
  }

  async paste () {
    const digits = (await navigator.clipboard.readText()).trim().split('')
    this
      .digitTargets
      .slice(0, digits.length)
      .forEach((target, index) => {
        target.value = digits[index]
        target.focus()
      })
  }

  navigateLeft ({ target }) {
    this.digitTargets[this.digitTargets.indexOf(target) - 1]?.focus()
  }

  navigateRight ({ target }) {
    this.digitTargets[this.digitTargets.indexOf(target) + 1]?.focus()
  }
}
