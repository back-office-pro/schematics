import ApplicationController from './application_controller'

/* global FormData, File, Routes */

export default class extends ApplicationController {
  static get targets () {
    return ['form', 'feedback']
  }

  static get values () {
    return { draft: Object }
  }

  connect () {
    this.formTarget.addEventListener('change', this.save.bind(this))
    this.formTarget.addEventListener('submit', this.clear.bind(this))
    Object.keys(this.draftValue).length && this.restore()
  }

  disconnect () {
    this.formTarget.removeEventListener('change', this.save.bind(this))
    this.formTarget.removeEventListener('submit', this.clear.bind(this))
  }

  async save () {
    if (Object.keys(this.draftValue).length === 0) {
      const response = await this.fetchAPI(Routes.draftsEn(), 'POST', this.params)
      this.draftValue = await response.json()
    } else {
      this.fetchAPI(Routes.draftEn(this.draftValue.id), 'PUT', this.params)
    }
    // TODO update feedback
  }

  async restore () {
    Object
      .entries(this.draftValue.data)
      .forEach(([key, value]) => { this.formTarget.querySelector(`[name='${key}']`).value = value })
  }

  clear () {
    this.fetchAPI(Routes.draftEn(this.draftValue.id), 'DELETE')
  }

  get params () {
    return {
      draft: {
        name: this.formTarget.id,
        data: this.filteredFormData
      }
    }
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
    return ['authenticity_token', 'password', 'lock_version']
  }
}
