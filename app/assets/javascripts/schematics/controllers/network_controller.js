import ApplicationController from 'controllers/application_controller'

export default class extends ApplicationController {
  static get targets () {
    return ['online', 'offline']
  }

  connect () {
    window.addEventListener('online', this.toggle.bind(this))
    window.addEventListener('offline', this.toggle.bind(this))
  }

  disconnect () {
    window.removeEventListener('online', this.toggle.bind(this))
    window.removeEventListener('offline', this.toggle.bind(this))
  }

  toggle () {
    this.onlineTarget.classList.toggle('d-none')
    this.offlineTarget.classList.toggle('d-none')
  }
}
