import ApplicationController from 'controllers/application_controller'
import autosize from 'autosize'

export default class extends ApplicationController {
  connect () {
    this.#create()
    this.element.addEventListener('focus', this.#update.bind(this))
  }

  disconnect () {
    this.#destroy()
    this.element.removeEventListener('focus', this.#update.bind(this))
  }

  #create () {
    autosize(this.element)
  }

  #update () {
    autosize.update(this.element)
  }

  #destroy () {
    autosize.destroy(this.element)
  }
}
