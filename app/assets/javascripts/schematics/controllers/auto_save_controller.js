import ApplicationController from 'controllers/application_controller'

/* global FormData, File, routes */

export default class extends ApplicationController {
  static get targets () {
    return ['form', 'button', 'restoreButton', 'timeago']
  }

  static get values () {
    return { draft: Object }
  }

  connect () {
    this.formTarget.addEventListener('change', this.debounce(this.save))
  }

  disconnect () {
    this.formTarget.removeEventListener('change', this.debounce(this.save))
  }

  async save () {
    this.fetchAPI(this.url, 'PUT', this.params)
    this.hasRestoreButtonTarget && this.hideRestoreButton()
    this.buttonTarget.classList.remove('d-none')
    this.timeagoTarget.setAttribute('datetime', new Date().toJSON())
    this.timeagoController.disconnect()
    this.timeagoController.connect()
  }

  restore () {
    this.hideRestoreButton()
    Object
      .entries(this.draftValue.data)
      .forEach(([key, value]) =>
        this
          .element
          .querySelector(`[name='${key}']`)
          ?.setAttribute('value', value)
      )
  }

  hideRestoreButton () {
    this.restoreButtonTarget.classList.add('d-none')
  }

  get params () {
    return { draft: { data: this.filteredFormData } }
  }

  get url () {
    return routes.draft.replace(':id', this.draftValue.id)
  }

  get formData () {
    return Object.fromEntries(new FormData(this.formTarget))
  }

  get filteredFormData () {
    return Object.fromEntries(
      Object
        .entries(this.formData)
        .filter(([key, _]) => !this.denylist.some(_ => key.includes(_)))
        .filter(([_, value]) => !(value instanceof File))
        .filter(([_, value]) => value !== '')
    )
  }

  get denylist () {
    return ['authenticity_token', '_method', 'password', 'lock_version']
  }

  get timeagoController () {
    return this.application.getControllerForElementAndIdentifier(this.timeagoTarget, 'timeago')
  }
}
