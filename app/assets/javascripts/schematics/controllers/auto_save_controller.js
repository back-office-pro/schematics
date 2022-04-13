import ApplicationController from './application_controller'

/* global FormData, File, Routes */

export default class extends ApplicationController {
  static get values () {
    return { draft: Object }
  }

  connect () {
    this.element.addEventListener('change', this.save.bind(this))
    this.element.addEventListener('submit', this.clear.bind(this))
    Object.keys(this.draftValue).length && this.restore()
  }

  disconnect () {
    this.element.removeEventListener('change', this.save.bind(this))
    this.element.removeEventListener('submit', this.clear.bind(this))
  }

  async save () {
    if (Object.keys(this.draftValue).length === 0) {
      const response = await this.fetchAPI(Routes.draftsEn(), 'POST', this.params)
      this.draftValue = await response.json()
    } else {
      this.fetchAPI(Routes.draftEn(this.draftValue.id), 'PUT', this.params)
    }
  }

  async restore () {
    Object
      .entries(this.draftValue.data)
      .forEach(([key, value]) =>
        this
          .element
          .querySelector(`[name='${key}']`)
          ?.setAttribute('value', value)
      )
  }

  clear () {
    this.fetchAPI(Routes.draftEn(this.draftValue.id), 'DELETE')
  }

  get params () {
    return {
      draft: {
        name: this.element.id,
        data: this.filteredFormData
      }
    }
  }

  get formData () {
    return Object.fromEntries(new FormData(this.element))
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
