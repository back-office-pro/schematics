window.application.register('notificationCenter', class extends Stimulus.Controller {
  static get targets() {
    return ['badge', 'icon']
  }

  async readNotifications() {
    if (this.targets.has('badge') && this.badgeTarget.classList.contains('animate__zoomIn')) {
      await fetchAPI('/dashboard/read_notifications', 'POST')
      this.badgeTarget.classList.remove('animate__zoomIn')
      this.badgeTarget.classList.add('animate__fadeOut')
      this.iconTarget.classList.remove('animate__animated', 'text-primary')
    }
  }
})
