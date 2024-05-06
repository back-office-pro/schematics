import ApplicationController from 'controllers/application_controller'

/* global Turbo, routes */

export default class extends ApplicationController {
  static get targets () {
    return ['button', 'switch']
  }

  async submit () {
    this.buttonTarget.disabled = true
    const params = { bulk_action: { ids: this.ids() } }
    const response = await this.fetchAPI(`${window.location.pathname}/${routes.bulk_actions}/${routes.archive}`, 'DELETE', params)
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
