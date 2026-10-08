import ApplicationController from 'controllers/application_controller'

/* global Turbo, routes */

export default class extends ApplicationController {
  static get targets () {
    return ['button', 'switch']
  }

  async submit () {
    this.buttonTarget.disabled = true
    const response = await this.fetchAPI(this.url, 'POST', this.params)
    Turbo.visit(response.headers.get('Location'))
  }

  toggleButton () {
    if (this.hasButtonTarget) {
      this.buttonTarget.classList.toggle('d-none', this.ids().length < 2)
    }
  }

  ids () {
    return this
      .switchTargets
      .filter(_ => _.checked)
      .map(_ => _.name)
  }

  get params () {
    return { bulk_action: { ids: this.ids() } }
  }

  get url () {
    return `${window.location.pathname}/${routes.bulkActions}`
  }
}
