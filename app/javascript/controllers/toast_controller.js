import ApplicationController from 'controllers/application_controller'
import { Toast } from 'bootstrap'

export default class extends ApplicationController {
  connect () {
    new Toast(this.element).show() // eslint-disable-line no-new
  }
}
