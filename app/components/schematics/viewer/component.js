import { Controller } from '../@hotwired/stimulus/dist/stimulus'

/* global Routes, Turbolinks, fetchAPI */

export class ComparisonController extends Controller {
  static get targets () {
    return ['button', 'switch']
  }

  static get values () {
    return { model: String }
  }

  async compare () {
    const params = { comparison: { model: this.modelValue, ids: this.ids() } }
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
