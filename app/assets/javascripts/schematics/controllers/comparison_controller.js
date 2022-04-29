import ApplicationController from './application_controller'
import { comparisonsEn } from 'routes'

/* global Turbo */

export default class extends ApplicationController {
  static get targets () {
    return ['button', 'switch']
  }

  static get values () {
    return { model: String }
  }

  async compare () {
    const params = { comparison: { model: this.modelValue, ids: this.ids() } }
    const response = await this.fetchAPI(comparisonsEn(), 'POST', params)
    const { pathname } = new URL(response.headers.get('Location'))
    Turbo.visit(pathname)
  }

  toggleButton () {
    this.buttonTarget.classList.toggle('d-none', this.ids().length >= 2)
  }

  ids () {
    return this
      .switchTargets
      .filter(_ => _.checked)
      .map(_ => _.name)
  }
}
