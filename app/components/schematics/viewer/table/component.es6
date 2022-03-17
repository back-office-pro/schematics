/* global Stimulus */

window.ComparisonController = class extends Stimulus.Controller {
  static get targets () {
    return ['button', 'switch']
  }

  async submit () {
    const params = { comparison: { model: this.data.get('model'), ids: this.ids() } }
    const response = await fetchAPI(Routes.comparisonsEn(), 'POST', params)
    const { id } = await response.json()
    Turbolinks.visit(Routes.comparisonEn({ id }))
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
