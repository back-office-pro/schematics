import ApplicationController from 'controllers/application_controller'

export default class extends ApplicationController {
  initialize () {
    this.parentNode = this.modalElement.parentNode
  }

  connect () {
    this.element.addEventListener('show.bs.modal', this.appendToBody.bind(this))
    this.element.addEventListener('hidden.bs.modal', this.moveBackToParentNode.bind(this))
  }

  disconnect () {
    this.element.removeEventListener('show.bs.modal', this.appendToBody.bind(this))
    this.element.removeEventListener('hidden.bs.modal', this.moveBackToParentNode.bind(this))
  }

  appendToBody () {
    document.body.appendChild(this.modalElement)
  }

  moveBackToParentNode () {
    this.parentNode.appendChild(this.modalElement)
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
