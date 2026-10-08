import ApplicationController from 'controllers/application_controller'

export default class extends ApplicationController {
  connect () {
    this.element.addEventListener('input', this.#replaceSpecialCharacters)
  }

  disconnect () {
    this.element.removeEventListener('input', this.#replaceSpecialCharacters)
  }

  #replaceSpecialCharacters () {
    this.value = this
      .value
      .normalize('NFD')
      .replace(/\p{Diacritic}/gu, '')
      .replace(/[\s-/]+/g, '_')
      .toLowerCase()
  }
}
