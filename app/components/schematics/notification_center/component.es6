/* global Stimulus, fetchAPI, Routes */

window.NotificationCenterController = class extends Stimulus.Controller {
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
