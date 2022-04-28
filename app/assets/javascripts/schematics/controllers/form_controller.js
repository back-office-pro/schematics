import ApplicationController from './application_controller'

export default class extends ApplicationController {
  static get targets () {
    return ['passwordInput']
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
