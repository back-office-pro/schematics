import ApplicationController from './application_controller'

export default class extends ApplicationController {
  connect () {
    this.element.addEventListener('show.bs.modal', this.appendToBody.bind(this))
  }

  disconnect () {
    this.element.removeEventListener('show.bs.modal', this.appendToBody.bind(this))
  }

  appendToBody () {
    document.body.appendChild(this.modalElement)
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
