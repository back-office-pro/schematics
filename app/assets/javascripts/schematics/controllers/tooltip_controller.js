import ApplicationController from './application_controller'

/* global bootstrap */

export default class extends ApplicationController {
  connect () {
    new bootstrap.Tooltip(this.element) // eslint-disable-line no-new
  }
}
