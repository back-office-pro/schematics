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

/* global FileReader, Image */

export default class extends ApplicationController {
  static get targets () {
    return ['container', 'input']
  }

  preview () {
    this.containerTarget.replaceChildren(...this.files.map(this.#readAndCreateImage))
  }

  get files () {
    return [...this.inputTarget.files].filter((file) => /\.(jpe?g|png|gif)$/i.test(file.name))
  }

  #readAndCreateImage (file) {
    const reader = new FileReader()
    const image = new Image()
    image.height = 100
    image.title = file.name
    image.classList.add('animate__animated', 'animate__zoomIn', 'rounded', 'me-2', 'mb-2')
    reader.addEventListener('load', () => { image.src = reader.result })
    reader.readAsDataURL(file)
    return image
  }
}
