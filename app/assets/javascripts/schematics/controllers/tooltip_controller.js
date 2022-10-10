import ApplicationController from 'controllers/application_controller'
import { Tooltip } from 'bootstrap'

export default class extends ApplicationController {
  connect () {
    new Tooltip(this.element) // eslint-disable-line no-new
  }
}
