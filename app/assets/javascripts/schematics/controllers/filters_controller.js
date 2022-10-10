import ApplicationController from 'controllers/application_controller'

export default class extends ApplicationController {
  connect () {
    this.element.addEventListener('submit', this.compactBlankInputs)
  }

  disconnect () {
    this.element.removeEventListener('submit', this.compactBlankInputs)
  }

  compactBlankInputs () {
    Array
      .from(this.elements)
      .filter(_ => !_.value)
      .forEach(_ => { _.disabled = true })
  }
}
