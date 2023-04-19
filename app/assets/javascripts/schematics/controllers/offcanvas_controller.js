import ApplicationController from 'controllers/application_controller'
import { Offcanvas } from 'bootstrap'

export default class extends ApplicationController {
  connect () {
    if (window.location.hash.substring(1) === this.element.id) {
      new Offcanvas(this.element).show()
    }
  }
}
