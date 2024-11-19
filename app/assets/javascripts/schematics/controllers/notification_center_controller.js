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
