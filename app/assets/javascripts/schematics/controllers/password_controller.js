import ApplicationController from './application_controller'

export default class extends ApplicationController {
  static get targets () {
    return ['input']
  }

  toggle () {
    this
      .inputTarget
      .setAttribute('type', this.inputTarget.type === 'text' ? 'password' : 'text')
    this
      .inputTarget
      .nextSibling
      .querySelectorAll('.icon')
      .forEach(_ => _.classList.toggle('d-none'))
  }
}
