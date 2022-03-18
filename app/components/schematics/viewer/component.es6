/* global Stimulus, Routes, Turbolinks, fetchAPI */

window.ComparisonController = class extends Stimulus.Controller {
  static get targets () {
    return ['button', 'switch']
  }

  async submit () {
    const params = { comparison: { model: this.data.get('model'), ids: this.ids() } }
    const response = await fetchAPI(Routes.comparisonsEn(), 'POST', params)
    const { pathname } = new URL(response.headers.get('Location'))
    Turbolinks.visit(pathname)
  }

  toggleButton () {
    if (this.ids().length >= 2) {
      this.buttonTarget.classList.remove('d-none')
    } else {
      this.buttonTarget.classList.add('d-none')
    }
  }

  ids () {
    return this
      .switchTargets
      .filter(_ => _.checked)
      .map(_ => _.name)
  }
}
