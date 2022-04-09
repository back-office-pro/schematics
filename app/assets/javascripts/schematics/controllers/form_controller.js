import { Controller } from '../../@hotwired/stimulus/dist/stimulus'

export default class extends Controller {
  static get targets () {
    return ['submitButton', 'passwordInput']
  }

  connect () {
    this.element.addEventListener('submit', this.toggleSubmitButton.bind(this))
    this.element.addEventListener('ajax:complete', this.toggleSubmitButton.bind(this))
  }

  disconnect () {
    this.element.removeEventListener('submit', this.toggleSubmitButton.bind(this))
    this.element.removeEventListener('ajax:complete', this.toggleSubmitButton.bind(this))
  }

  toggleSubmitButton (e) {
    e.stopImmediatePropagation()
    this.submitButtonTarget.disabled = !this.submitButtonTarget.disabled
    this
      .submitButtonTarget
      .querySelectorAll('.icon')
      .forEach(_ => _.classList.toggle('d-none'))
    this
      .submitButtonTarget
      .querySelectorAll('.text')
      .forEach(_ => _.classList.toggle(_.classList.contains('d-lg-inline') ? 'd-lg-inline' : 'd-none'))
  }

  togglePasswordValue () {
    const { type } = this.passwordInputTarget
    this
      .passwordInputTarget
      .setAttribute('type', type === 'text' ? 'password' : 'text')
    this
      .passwordInputTarget
      .nextSibling
      .querySelectorAll('.icon')
      .forEach(_ => _.classList.toggle('d-none'))
  }
}
