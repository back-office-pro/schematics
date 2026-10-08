import ApplicationController from 'controllers/application_controller'

/* global I18n */

export default class extends ApplicationController {
  static get values () {
    return { version: String }
  }

  static get targets () {
    return ['icon', 'text']
  }

  async connect () {
    const response = await fetch('https://www.back-office.pro/latest')
    const { version } = await response.json()
    this.iconTarget.classList.remove('fa-spinner', 'fa-spin')
    if (version === this.versionValue) {
      this.textTarget.textContent = I18n.softwareUpdate.upToDate
      this.iconTarget.classList.add('fa-cloud-arrow-up')
    } else {
      this.textTarget.textContent = I18n.softwareUpdate.outdated
      this.iconTarget.classList.add('fa-triangle-exclamation')
    }
  }
}
