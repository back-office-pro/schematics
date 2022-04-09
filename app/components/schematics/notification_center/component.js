import ApplicationController from '../schematics/controllers/application_controller'

/* global Routes */

export default class extends ApplicationController {
  static get targets () {
    return ['badge', 'icon']
  }

  hasNotifications () {
    return this.targets.has('badge') && this.badgeTarget.classList.contains('animate__zoomIn')
  }

  async readNotifications () {
    if (this.hasNotifications()) {
      await this.fetchAPI(Routes.schematicsDashboardReadNotifications(), 'POST')
      this.badgeTarget.classList.remove('animate__zoomIn')
      this.badgeTarget.classList.add('animate__fadeOut')
      this.iconTarget.classList.remove('animate__animated')
    }
  }
}
