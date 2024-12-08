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
