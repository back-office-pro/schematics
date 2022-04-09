import { Controller } from '../../@hotwired/stimulus/dist/stimulus'

export default class extends Controller {
  connect () {
    this.element.addEventListener('show.bs.modal', this.appendToBody.bind(this))
  }

  disconnect () {
    this.element.removeEventListener('show.bs.modal', this.appendToBody.bind(this))
  }

  appendToBody () {
    document.body.appendChild(this.element.parentNode)
  }
}
