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
