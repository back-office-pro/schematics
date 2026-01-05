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
import autosize from 'autosize'

export default class extends ApplicationController {
  connect () {
    this.#create()
    this.element.addEventListener('focus', this.#update.bind(this))
  }

  disconnect () {
    this.#destroy()
    this.element.removeEventListener('focus', this.#update.bind(this))
  }

  #create () {
    autosize(this.element)
  }

  #update () {
    autosize.update(this.element)
  }

  #destroy () {
    autosize.destroy(this.element)
  }
}
