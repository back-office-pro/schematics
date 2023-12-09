import ApplicationController from 'controllers/application_controller'

/* global Turbo, routes */

export default class extends ApplicationController {
  static get targets () {
    return ['button', 'switch']
  }

  static get values () {
    return { model: String }
  }

  async compare () {
    this.buttonTarget.disabled = true
    const params = { comparison: { model: this.modelValue, ids: this.ids() } }
    const response = await this.fetchAPI(routes.comparisons, 'POST', params)
    Turbo.visit(response.headers.get('Location'))
  }

  toggleButton () {
    this.buttonTarget.classList.toggle('d-none', this.ids().length < 2)
  }

  ids () {
    return this
      .switchTargets
      .filter(_ => _.checked)
      .map(_ => _.name)
  }
}
