import { Controller } from '../@hotwired/stimulus/dist/stimulus'

/* global fetchAPI, Routes */

export default class extends Controller {
  static get targets () {
    return ['badge', 'icon']
  }

  hasNotifications () {
    return this.targets.has('badge') && this.badgeTarget.classList.contains('animate__zoomIn')
  }

  async readNotifications () {
    if (this.hasNotifications()) {
      await fetchAPI(Routes.schematicsDashboardReadNotifications(), 'POST')
      this.badgeTarget.classList.remove('animate__zoomIn')
      this.badgeTarget.classList.add('animate__fadeOut')
      this.iconTarget.classList.remove('animate__animated')
    }
  }
}
