import ApplicationController from 'controllers/application_controller'
import autosize from 'autosize'

export default class extends ApplicationController {
  connect () {
    autosize(this.element)
  }

  disconnect () {
    autosize.destroy(this.element)
  }
}
