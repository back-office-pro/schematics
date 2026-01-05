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
  initialize () {
    this.parentNode = this.modalElement.parentNode
    this.element.addEventListener('show.bs.modal', this.#appendToBody.bind(this))
    this.element.addEventListener('hide.bs.modal', this.#checkFormValidity.bind(this))
    this.element.addEventListener('hidden.bs.modal', this.#moveBackToParentNode.bind(this))
  }

  #appendToBody () {
    document.body.append(this.modalElement)
  }

  #moveBackToParentNode () {
    this.parentNode.prepend(this.modalElement)
  }

  #checkFormValidity (event) {
    Array
      .from(this.modalElement.querySelectorAll('input, select'))
      .every(_ => _.reportValidity()) || event.preventDefault()
  }

  get modalElement () {
    switch (this.element.parentNode.tagName) {
      case 'FORM':
        return this.element.parentNode
      default:
        return this.element
    }
  }
}
