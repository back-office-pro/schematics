import ApplicationController from 'controllers/application_controller'

export default class extends ApplicationController {
  initialize () {
    this.parentNode = this.modalElement.parentNode
    this.element.addEventListener('show.bs.modal', this.#appendToBody.bind(this))
    this.element.addEventListener('hide.bs.modal', this.#checkFormValidity.bind(this))
    this.element.addEventListener('hidden.bs.modal', this.#moveBackToParentNode.bind(this))
  }

  #appendToBody () {
    document.body.append(this.modalElement)
  }

  #moveBackToParentNode () {
    this.parentNode.prepend(this.modalElement)
  }

  #checkFormValidity (event) {
    Array
      .from(this.modalElement.querySelectorAll('input, select'))
      .every(_ => _.reportValidity()) || event.preventDefault()
  }

  get modalElement () {
    switch (this.element.parentNode.tagName) {
      case 'FORM':
        return this.element.parentNode
      default:
        return this.element
    }
  }
}
